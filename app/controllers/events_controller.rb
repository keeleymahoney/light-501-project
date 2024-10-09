# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]

  # GET /events or /events.json
  def index
    @events = Event.all
  end

  # GET /events/1 or /events/1.json
  def show
    @event = Event.find(params[:id])
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events or /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        handle_image_uploads
        format.html { redirect_to event_url(@event), notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        handle_image_uploads
        format.html { redirect_to event_url(@event), notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def delete
    @event = Event.find(params[:id])
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def rsvp_form
    require 'google/apis/forms_v1'

    @event = Event.find(params[:id])

    rsvp_form_id = Event.find(params[:id]).rsvp_link

    # Check that there is an rsvp form to show
    if defined?(rsvp_form_id) && !rsvp_form_id.blank?
      if current_member.token_exp_date <= Time.now.to_i
        redirect_to member_google_oauth2_omniauth_authorize_path
      end

      begin
        @form_exists = true

        forms = Google::Apis::FormsV1::FormsService.new

        forms.authorization = current_member.google_token

        rsvp_form_responses = forms.list_form_responses(rsvp_form_id)
        rsvp_form = forms.get_form(rsvp_form_id)

        @form_submission_link = rsvp_form.responder_uri
        @form_edit_link = "https://docs.google.com/forms/d/#{rsvp_form_id}/edit"

        @num_responses = 0

        unless rsvp_form_responses.responses.blank?
          rsvp_form_responses.responses.each do |_r|
            @num_responses += 1
          end
        end
      rescue
        redirect_to root_path, notice: 'Something went wrong. Please try again later.'
      end

    else
      @form_exists = false
      @num_responses = 0
    end
  end

  def create_form
    require 'google/apis/forms_v1'
    require 'google/apis/drive_v3'

    @event = Event.find(params[:id])

    rsvp_form_id = Event.find(params[:id]).rsvp_link

    # Create a form if no form exists already. Else, re-render current page
    if !defined?(rsvp_form_id) || rsvp_form_id.blank?
      if current_member.token_exp_date <= Time.now.to_i
        redirect_to member_google_oauth2_omniauth_authorize_path
      end

      begin
        forms = Google::Apis::FormsV1::FormsService.new
        drive = Google::Apis::DriveV3::DriveService.new

        forms.authorization = current_member.google_token

        @new_form = forms.create_form(
          {
            info: {
              title: 'New Form'
            }
          }
        )

        forms_request = Google::Apis::FormsV1::BatchUpdateFormRequest.new(requests: rsvp_form_default_params)

        forms.batch_update_form(@new_form.form_id, forms_request)

        # Check that event entity is updated successfully
        if @event.update(rsvp_link: @new_form.form_id)
          redirect_to rsvp_form_event_path(@event), notice: 'RSVP form successfully created.'
        else
          render('rsvp_form')
        end
      rescue
        redirect_to root_path, notice: 'Could not create RSVP form. Please try again later.'
      end        
    else
      redirect_to rsvp_form_event_path(@event), notice: 'A form already exists.'
    end
  end

  def delete_rsvp_form
    @event = Event.find(params[:id])
  end  

  def destroy_form
    require 'google/apis/drive_v3'

    @event = Event.find(params[:id])

    rsvp_form_id = Event.find(params[:id]).rsvp_link

    # Delete a form if a form exists already. Else, re-render current page
    if defined?(rsvp_form_id) && !rsvp_form_id.blank?
      if current_member.token_exp_date <= Time.now.to_i
        redirect_to member_google_oauth2_omniauth_authorize_path
      end
      
      begin
        drive = Google::Apis::DriveV3::DriveService.new

        drive.authorization = current_member.google_token

        drive.delete_file(rsvp_form_id)

        # Check that event entity is updated successfully
        if @event.update(rsvp_link: '')
          redirect_to rsvp_form_event_path(@event), notice: 'RSVP form was successfully destroyed.'
        else
          render('rsvp_form')
        end
      rescue
        redirect_to root_path, notice: 'Could not destroy RSVP form. Please try again later.'
      end

    else 
        redirect_to rsvp_form_event_path(@event), notice: 'This form has already been deleted.'
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params[:id])
  end

  def handle_image_uploads
    return unless params[:event][:images].present?

    params[:event][:images].each do |image|
      next if image.blank?

      # Use ImagesController to create images
      @event.event_images.create(picture: image.read)
    end
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:id, :name, :date, :description, :location, :rsvp_link, :feedback_link)
  end

  def rsvp_form_default_params
    [      
      {
        update_form_info: {
          info: {
            title: "RSVP Form For " + @event.name
          },
          update_mask: "title"
        }
      },                 
      {
        create_item: {
          item: {
            title: "Will you be attending?",
            question_item: {
              question: {
                required: true,
                choice_question: {
                  type: "RADIO",
                  options: [
                    { value: "Yes" },
                    { value: "No" }
                  ],
                  shuffle: false
                }
              }
            }
          },
          location: {
            index: 0
          }
        }
      }, 
      {
        create_item: {
          item: {
            title: "Name",
            question_item: {
              question: {
                required: true,
                text_question: {
                  "paragraph": false
                }
              }
            }
          },
          location: {
            index: 1
          }
        }
      },
      {
        create_item: {
          item: {
            title: "Email",
            question_item: {
              question: {
                required: true,
                text_question: {
                  "paragraph": false
                }
              }
            }
          },
          location: {
            index: 2
          }
        }
      },
      {
        create_item: {
          item: {
            title: "How did you hear about us?",
            question_item: {
              question: {
                required: false,
                text_question: {
                  "paragraph": true
                }
              }
            }
          },
          location: {
            index: 3
          }
        }
      },
      {
        create_item: {
          item: {
            title: "Do you have any comments or questions?",
            question_item: {
              question: {
                required: false,
                text_question: {
                  "paragraph": true
                }
              }
            }
          },
          location: {
            index: 4
          }
        }
      }                                 
    ]  
  end
end
