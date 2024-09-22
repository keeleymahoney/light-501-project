class FormsController < ApplicationController
  require 'google/apis/forms_v1'
  require 'google/apis/drive_v3'

  def create
    forms = Google::Apis::FormsV1::FormsService.new
    drive = Google::Apis::DriveV3::DriveService.new

    form_scopes = ['https://www.googleapis.com/auth/forms.body']
    forms.authorization = Google::Auth.get_application_default(form_scopes)

    drive_scopes = ['https://www.googleapis.com/auth/drive']
    drive.authorization = Google::Auth.get_application_default(drive_scopes)    
    
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

    @drive_list = drive.list_files()
    
  end

  def monitor
    forms = Google::Apis::FormsV1::FormsService.new

    scopes = ['https://www.googleapis.com/auth/forms.responses.readonly']
    forms.authorization = Google::Auth.get_application_default(scopes)

    @rsvp_form = forms.list_form_responses(formId='1IS7NqkaJjabeqtH_zD5diJfKwP62Zcb_9F5bTiIoWtI') # Remove once Event entity available
    # @curr_form = forms.list_form_responses(formId=rsvp_form_id)
    @rsvp_responses = 0

    @feedback_form = forms.list_form_responses(formId='1PlCUYNTYhGXwLDQGJLbgedW4abpZoq1wpjWVW_bemjI') # Remove once Event entity available
    # @curr_form = forms.list_form_responses(formId=feedback_form_id)
    @feedback_responses = 0    
  end

  def respond
    forms = Google::Apis::FormsV1::FormsService.new

    scopes = ['https://www.googleapis.com/auth/forms.body.readonly']
    forms.authorization = Google::Auth.get_application_default(scopes)

    @rsvp_form = forms.get_form(formId='1IS7NqkaJjabeqtH_zD5diJfKwP62Zcb_9F5bTiIoWtI') # Remove once Event entity available
    @feedback_form = forms.get_form(formId='1PlCUYNTYhGXwLDQGJLbgedW4abpZoq1wpjWVW_bemjI') # Remove once Event entity available
  end

  private
    def rsvp_form_id
      # Event.find(params[:id]).rsvp_form_id
    end

    def feedback_form_id
      # Event.find(params[:id]).feedback_form_id
    end
end
