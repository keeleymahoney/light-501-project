class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]

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
        format.html { redirect_to event_url(@event), notice: "Event was successfully created." }
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
        handle_image_uploads()
        format.html { redirect_to event_url(@event), notice: "Event was successfully updated." }
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
      format.html { redirect_to events_url, notice: "Event was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def rsvp_form
    require 'google/apis/forms_v1'
    require 'google/apis/drive_v3'

    @event = Event.find(params[:id])

    rsvp_form_id = Event.find(params[:id]).rsvp_link

    # Check that there is an rsvp form to show
    if defined?(rsvp_form_id) && !rsvp_form_id.blank?
      @form_exists = true

      forms = Google::Apis::FormsV1::FormsService.new

      scopes = ['https://www.googleapis.com/auth/forms.responses.readonly', 'https://www.googleapis.com/auth/forms.body.readonly']
      forms.authorization = Google::Auth.get_application_default(scopes)

      rsvp_form_responses = forms.list_form_responses(formId=rsvp_form_id)
      rsvp_form = forms.get_form(formId=rsvp_form_id)

      @form_title = rsvp_form.info.title
      @form_submission_link = rsvp_form.responder_uri

      @num_responses = 0

      if !rsvp_form_responses.responses.blank?
        for r in rsvp_form_responses.responses do
          @num_responses = @num_responses + 1
        end
      end

    else
      @form_exists = false
      @num_responses = 0
    end

  end  

  def create_form
    # kasjsdalkfjasdf

    require 'google/apis/forms_v1'
    require 'google/apis/drive_v3'

    # di_to(events_path)

    @event = Event.find(params[:id])

    rsvp_form_id = Event.find(params[:id]).rsvp_link

    # Check that no form exists already
    if !defined?(rsvp_form_id) || rsvp_form_id.blank? # TODO: add once Event entity available
      forms = Google::Apis::FormsV1::FormsService.new
      drive = Google::Apis::DriveV3::DriveService.new

      form_scopes = ['https://www.googleapis.com/auth/forms.body']
      forms.authorization = Google::Auth.get_application_default(form_scopes)

      drive_scopes = ['https://www.googleapis.com/auth/drive.file']
      drive.authorization = Google::Auth.get_application_default(drive_scopes)   
      
      @new_form = forms.create_form(
        {
          "info": {
            "title": "New Form"
          }
        }      
      )    

      @form_permissions = drive.create_permission(fileId=@new_form.form_id,{
        'email_address': 'test4light2day@gmail.com',
        'type': 'user',
        'role': 'writer'
      }) # TODO: replace hard-coded email before pushing to github

      # @event.rspv_link = @new_form.form_id

      if @event.update(rsvp_link: @new_form.form_id)
        # flash[:notice] = 'Form successfully created!'
        redirect_to rsvp_form_event_path(@event)
      else
        render('rsvp_form')
      end
    else 
      # flash notice that a form already exists and re-render show_rsvp page # TODO: add once Event entity available
      render('rsvp_form')

    end # TODO: add once Event entity available
    
  end  

  def edit_form
    @event = Event.find(params[:id])

    rsvp_form_id = Event.find(params[:id]).rsvp_link

    if !defined?(rsvp_form_id) || rsvp_form_id.blank? # TODO: add once Event entity available
      # flash notice that a form does not exist and re-render show_rsvp page # TODO: add once Event entity available
    else # TODO: add once Event entity available
      # edit_url = 'https://docs.google.com/forms/d/1IS7NqkaJjabeqtH_zD5diJfKwP62Zcb_9F5bTiIoWtI/edit' # TODO: remove once Event entity available
    edit_url = 'https://docs.google.com/forms/d/' + rsvp_form_id + '/edit' # TODO: add once Event entity available
      redirect_to(edit_url, allow_other_host: true)
    # end # TODO: add once Event entity available
    end
  end  

  def delete_form
    require 'google/apis/drive_v3'

    # di_to(events_path)

    @event = Event.find(params[:id])

    rsvp_form_id = Event.find(params[:id]).rsvp_link

    # Check that a form exists already
    if defined?(rsvp_form_id) && !rsvp_form_id.blank? # TODO: add once Event entity available
      drive = Google::Apis::DriveV3::DriveService.new

      drive_scopes = ['https://www.googleapis.com/auth/drive.file']
      drive.authorization = Google::Auth.get_application_default(drive_scopes)   
      
      drive.delete_file(fileId=rsvp_form_id)

      # @event.rspv_link = @new_form.form_id

      if @event.update(rsvp_link: '')
        # flash[:notice] = 'Form successfully created!'
        redirect_to rsvp_form_event_path(@event)
      else
        render('rsvp_form')
      end
    else 
      # flash notice that a form already exists and re-render show_rsvp page # TODO: add once Event entity available
      render('rsvp_form')

    end # TODO: add once Event entity available
    
  end  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def handle_image_uploads
      if params[:event][:images].present?
        params[:event][:images].each do |image|
          next if image.blank?  
          # Use ImagesController to create images
          @event.event_images.create(picture: image.read)
        end
      end
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:id, :name, :date, :description, :location, :rsvp_link, :feedback_link)
    end

    # def rsvp_form_id
    #   Event.find(params[:id]).rsvp_link
    # end    
end
