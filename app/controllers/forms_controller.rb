class FormsController < ApplicationController
  require 'google/apis/forms_v1'
  require 'google/apis/drive_v3'

  def create_form
    # ----------------------------------------------------------------------------------
    # OLD CODE:

    # forms = Google::Apis::FormsV1::FormsService.new
    # drive = Google::Apis::DriveV3::DriveService.new

    # form_scopes = ['https://www.googleapis.com/auth/forms.body']
    # forms.authorization = Google::Auth.get_application_default(form_scopes)

    # drive_scopes = ['https://www.googleapis.com/auth/drive.file']
    # drive.authorization = Google::Auth.get_application_default(drive_scopes)    
    
    # @new_form = forms.create_form(
    #   {
    #     "info": {
    #       "title": "Test Create Form",
    #       "documentTitle": "Test Create Form",
    #     }
    #   }      
    # )
    
    # @form_permissions = drive.create_permission(fileId=@new_form.form_id,{
    #   'email_address': 'test4light2day@gmail.com',
    #   'type': 'user',
    #   'role': 'writer'
    # })

    # drive.delete_file(fileId='10laRvqXr8kVWv4-hDd-DbWwIsO-UI5AxbBJOxFeGRJg')

    # @drive_list = drive.list_files()
    # ----------------------------------------------------------------------------------    

    # if rsvp_form_id is null # TODO: add once Event entity available
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

      # TODO: add new form-id to Event
      # TODO: flash notice that form was created successfully and re-render show_rsvp page
      render('show_rsvp')
    # else # TODO: add once Event entity available
      # flash notice that a form already exists and re-render show_rsvp page # TODO: add once Event entity available

    # end # TODO: add once Event entity available
    
  end

  def edit_form
    # if rsvp_form_id is null # TODO: add once Event entity available
      # flash notice that a form does not exist and re-render show_rsvp page # TODO: add once Event entity available
    # else # TODO: add once Event entity available
    edit_url = 'https://docs.google.com/forms/d/1IS7NqkaJjabeqtH_zD5diJfKwP62Zcb_9F5bTiIoWtI/edit' # TODO: remove once Event entity available
    # edit_url = 'https://docs.google.com/forms/d/' + rsvp_form_id + '/edit' # TODO: add once Event entity available
    redirect_to(edit_url, allow_other_host: true)
    # end # TODO: add once Event entity available
  end

  def respond_rsvp
    forms = Google::Apis::FormsV1::FormsService.new

    scopes = ['https://www.googleapis.com/auth/forms.body.readonly']
    forms.authorization = Google::Auth.get_application_default(scopes)

    rsvp_form = forms.get_form(formId=rsvp_form_id)

    @rsvp_form_uri = rsvp_form.responder_uri
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
    def rsvp_form_id
      # Event.find(params[:id]).rsvp_form_id
      '1IS7NqkaJjabeqtH_zD5diJfKwP62Zcb_9F5bTiIoWtI'
    end

    # def feedback_form_id
    #   # Event.find(params[:id]).feedback_form_id
    # end
end
