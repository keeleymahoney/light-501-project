# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]
  before_action :check_if_signed_in

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

  def sign_in_form
    @event = Event.find(params[:id])
  end

  def show_rsvp_form
    require 'google/apis/forms_v1'

    @event = Event.find(params[:id])

    rsvp_form_id = Event.find(params[:id]).rsvp_id

    # Check that there is an rsvp form to show
    if defined?(rsvp_form_id) && !rsvp_form_id.blank?
      begin
        @form_exists = true

        forms = Google::Apis::FormsV1::FormsService.new

        forms.authorization = current_member.token.access_token

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
      rescue Google::Apis::ClientError => e
        if e.status_code == 404 # form cannot be found because you don't have access or it's been deleted
          if @event.update(rsvp_id: '')
            redirect_to events_path, notice: 'Your previous form was inaccessible or deleted. It has been unlinked from your event.'
          else
            redirect_to events_path, notice: 'Your form was unable to be accessed. Please try again.'
          end          
        else
          redirect_to events_path, notice: 'Something went wrong. Please try again later.'
        end
      rescue
        if current_member.token.nil? || current_member.token.token_exp.to_i <= Time.now.to_i
          redirect_to sign_in_form_event_path(@event)
        else
          redirect_to events_path, notice: 'Something went wrong. Please try again later.'
        end
      end
    else
      @form_exists = false
      @num_responses = 0
    end
  end

  def create_rsvp_form
    require 'google/apis/forms_v1'
    require 'google/apis/drive_v3'

    @event = Event.find(params[:id])

    rsvp_form_id = Event.find(params[:id]).rsvp_id

    # Create a form if no form exists already. Else, re-render current page
    if !defined?(rsvp_form_id) || rsvp_form_id.blank?
      begin
        forms = Google::Apis::FormsV1::FormsService.new
        drive = Google::Apis::DriveV3::DriveService.new

        forms.authorization = current_member.token.access_token
        drive.authorization = current_member.token.access_token

        @new_form = forms.create_form(
          {
            info: {
              title: 'New Form'
            }
          }
        )

        forms_request = Google::Apis::FormsV1::BatchUpdateFormRequest.new(requests: rsvp_form_default_params)

        forms.batch_update_form(@new_form.form_id, forms_request)

        drive.update_file(@new_form.form_id, {name: "RSVP Form For " + @event.name})

        # Check that event entity is updated successfully
        if @event.update(rsvp_id: @new_form.form_id)
          redirect_to show_rsvp_form_event_path(@event), notice: 'RSVP form successfully created.'
        else
          render('show_rsvp_form')
        end
      rescue
        if current_member.token.nil? || current_member.token.token_exp.to_i <= Time.now.to_i
          redirect_to sign_in_form_event_path(@event)
        else
          redirect_to events_path, notice: 'Could not create RSVP form. Please try again later.'
        end
      end        
    else
      redirect_to show_rsvp_form_event_path(@event), notice: 'A form already exists.'
    end
  end

  def delete_rsvp_form
    @event = Event.find(params[:id])
  end  

  def destroy_rsvp_form
    require 'google/apis/drive_v3'

    @event = Event.find(params[:id])

    rsvp_form_id = Event.find(params[:id]).rsvp_id

    # Delete a form if a form exists already. Else, re-render current page
    if defined?(rsvp_form_id) && !rsvp_form_id.blank?
      begin
        drive = Google::Apis::DriveV3::DriveService.new

        drive.authorization = current_member.token.access_token

        drive.delete_file(rsvp_form_id)

        # Check that event entity is updated successfully
        if @event.update(rsvp_id: '')
          redirect_to show_rsvp_form_event_path(@event), notice: 'RSVP form was successfully destroyed.'
        else
          render('show_rsvp_form')
        end
      rescue Google::Apis::ClientError => e
        if e.status_code == 404 # form cannot be found because you don't have access or it's been deleted
          if @event.update(rsvp_id: '')
            redirect_to events_path, notice: 'Your previous form was inaccessible. It has been unlinked from your event.'
          else
            redirect_to events_path, notice: 'Your form was unable to be accessed. Please try again.'
          end          
        else
          redirect_to events_path, notice: 'Could not destroy RSVP form. Please try again later.'
        end        
      rescue
        if current_member.token.nil? || current_member.token.token_exp.to_i <= Time.now.to_i
          redirect_to sign_in_form_event_path(@event)
        else        
          redirect_to events_path, notice: 'Could not destroy RSVP form. Please try again later.'
        end
      end
    else 
        redirect_to show_rsvp_form_event_path(@event), notice: 'This form has already been deleted.'
    end
  end

  def show_feedback_form
    require 'google/apis/forms_v1'

    @event = Event.find(params[:id])

    feedback_form_id = Event.find(params[:id]).feedback_id

    # Check that there is a feedback form to show
    if defined?(feedback_form_id) && !feedback_form_id.blank?
      begin
        @form_exists = true

        forms = Google::Apis::FormsV1::FormsService.new

        forms.authorization = current_member.token.access_token

        feedback_form_responses = forms.list_form_responses(feedback_form_id)
        feedback_form = forms.get_form(feedback_form_id)

        @form_submission_link = feedback_form.responder_uri
        @form_edit_link = "https://docs.google.com/forms/d/#{feedback_form_id}/edit"

        @num_responses = 0

        unless feedback_form_responses.responses.blank?
          feedback_form_responses.responses.each do |_r|
            @num_responses += 1
          end
        end
      rescue Google::Apis::ClientError => e
        if e.status_code == 404 # form cannot be found because you don't have access or it's been deleted
          if @event.update(feedback_id: '')
            redirect_to events_path, notice: 'Your previous form was inaccessible or deleted. It has been unlinked from your event.'
          else
            redirect_to events_path, notice: 'Your form was unable to be accessed. Please try again.'
          end          
        else
          redirect_to events_path, notice: 'Something went wrong. Please try again later.'
        end
      rescue
        if current_member.token.nil? || current_member.token.token_exp.to_i <= Time.now.to_i
          redirect_to sign_in_form_event_path(@event)
        else
          redirect_to events_path, notice: 'Something went wrong. Please try again later.'
        end
      end
    else
      @form_exists = false
      @num_responses = 0
    end
  end

  def create_feedback_form
    require 'google/apis/forms_v1'
    require 'google/apis/drive_v3'

    @event = Event.find(params[:id])

    feedback_form_id = Event.find(params[:id]).feedback_id

    # Create a form if no form exists already. Else, re-render current page
    if !defined?(feedback_form_id) || feedback_form_id.blank?
      begin
        forms = Google::Apis::FormsV1::FormsService.new
        drive = Google::Apis::DriveV3::DriveService.new

        forms.authorization = current_member.token.access_token
        drive.authorization = current_member.token.access_token

        @new_form = forms.create_form(
          {
            info: {
              title: 'New Form'
            }
          }
        )

        forms_request = Google::Apis::FormsV1::BatchUpdateFormRequest.new(requests: feedback_form_default_params)

        forms.batch_update_form(@new_form.form_id, forms_request)

        drive.update_file(@new_form.form_id, {name: "Feedback Form For " + @event.name})

        # Check that event entity is updated successfully
        if @event.update(feedback_id: @new_form.form_id)
          redirect_to show_feedback_form_event_path(@event), notice: 'Feedback form successfully created.'
        else
          render('show_feedback_form')
        end
      rescue
        if current_member.token.nil? || current_member.token.token_exp.to_i <= Time.now.to_i
          redirect_to sign_in_form_event_path(@event)
        else
          redirect_to events_path, notice: 'Could not create feedback form. Please try again later.'
        end
      end        
    else
      redirect_to show_feedback_form_event_path(@event), notice: 'A form already exists.'
    end
  end

  def delete_feedback_form
    @event = Event.find(params[:id])
  end  

  def destroy_feedback_form
    require 'google/apis/drive_v3'

    @event = Event.find(params[:id])

    feedback_form_id = Event.find(params[:id]).feedback_id

    # Delete a form if a form exists already. Else, re-render current page
    if defined?(feedback_form_id) && !feedback_form_id.blank?
      begin
        drive = Google::Apis::DriveV3::DriveService.new

        drive.authorization = current_member.token.access_token

        drive.delete_file(feedback_form_id)

        # Check that event entity is updated successfully
        if @event.update(feedback_id: '')
          redirect_to show_feedback_form_event_path(@event), notice: 'Feedback form was successfully destroyed.'
        else
          render('show_feedback_form')
        end
      rescue Google::Apis::ClientError => e
        if e.status_code == 404 # form cannot be found because you don't have access or it's been deleted
          if @event.update(feedback_id: '')
            redirect_to events_path, notice: 'Your previous form was inaccessible. It has been unlinked from your event.'
          else
            redirect_to events_path, notice: 'Your form was unable to be accessed. Please try again.'
          end          
        else
          redirect_to events_path, notice: 'Could not destroy feedback form. Please try again later.'
        end        
      rescue
        if current_member.token.nil? || current_member.token.token_exp.to_i <= Time.now.to_i
          redirect_to sign_in_form_event_path(@event)
        else        
          redirect_to events_path, notice: 'Could not destroy feedback form. Please try again later.'
        end
      end
    else 
        redirect_to show_feedback_form_event_path(@event), notice: 'This form has already been deleted.'
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
    params.require(:event).permit(:id, :name, :date, :description, :location, :rsvp_id, :feedback_id)
  end

  # def rsvp_form_id
  #   Event.find(params[:id]).rsvp_id
  # end
  def check_if_signed_in
    unless member_signed_in?
      redirect_to root_path, notice: 'You do not have access to this page. Please log in.'
    end
  end

  def rsvp_form_default_params
    [      
      {
        update_form_info: {
          info: {
            title: "RSVP Form For " + @event.name,
            description: 
            "-----------------------------------------------------------

CONTACT US:

E-mail:           info.boldrso@gmail.com

Linkedin:       linkedin.com/company/boldrso

Instagram:    instagram.com/boldrso"
          },
          update_mask: "title,description"
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
            title: "Do you have any questions or comments?",
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

  def feedback_form_default_params
    [      
      {
        update_form_info: {
          info: {
            title: "Feedback Form For " + @event.name,
            description: 
            "-----------------------------------------------------------

CONTACT US:

E-mail:           info.boldrso@gmail.com

Linkedin:       linkedin.com/company/boldrso

Instagram:    instagram.com/boldrso"
          },
          update_mask: "title,description"            
        }
      },                 
      {
        create_item: {
          item: {
            title: "Rate the value you gained from this event:",
            question_item: {
              question: {
                required: true,
                scale_question: {
                  low: 1,
                  high: 5,
                  low_label: "Not useful at all",
                  high_label: "Extremely useful"
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
            index: 1
          }
        }
      },
      {
        create_item: {
          item: {
            title: "Do you have any questions or comments?",
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
            index: 2
          }
        }
      }                                 
    ]  
  end  
end
