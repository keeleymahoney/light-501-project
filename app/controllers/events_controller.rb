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

  def show_rsvp
    # if rsvp_form_id is not null # TODO: add once Event entity available
      @form_exists = true

      forms = Google::Apis::FormsV1::FormsService.new

      scopes = ['https://www.googleapis.com/auth/forms.responses.readonly', 'https://www.googleapis.com/auth/forms.body.readonly']
      forms.authorization = Google::Auth.get_application_default(scopes)

      rsvp_form_responses = forms.list_form_responses(formId=rsvp_form_id)
      rsvp_form = forms.get_form(formId=rsvp_form_id)

      @form_title = rsvp_form.info.title
      @form_submission_link = rsvp_form.responder_uri

      @num_responses = 0

      for r in rsvp_form_responses.responses do
        @num_responses = @num_responses + 1
      end

    # else # TODO: add once Event entity available
      # @form_exists = false
      # @num_responses = 0 # TODO: add once Event entity available
    # end # TODO: add once Event entity available

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

    def rsvp_form_id
      Event.find(params[:id]).rsvp_link
    end    
end
