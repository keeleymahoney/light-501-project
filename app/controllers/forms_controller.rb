class FormsController < ApplicationController
  require 'google/apis/forms_v1'

  def create
  end

  def monitor
    forms = Google::Apis::FormsV1::FormsService.new

    scopes = ['https://www.googleapis.com/auth/forms.responses.readonly']
    forms.authorization = Google::Auth.get_application_default(scopes)

    @rsvp_form = forms.list_form_responses(formId='1RJfBCqaPYto6HBo-Z_BzHSGF-q-cLoROwMM3MhsvXt8') # Remove once Event entity available
    # @curr_form = forms.list_form_responses(formId=rsvp_form_id)
    @rsvp_responses = 0

    @feedback_form = forms.list_form_responses(formId='1PlCUYNTYhGXwLDQGJLbgedW4abpZoq1wpjWVW_bemjI') # Remove once Event entity available
    # @curr_form = forms.list_form_responses(formId=feedback_form_id)
    @feedback_responses = 0    
  end

  def respond
  end

  private
    def rsvp_form_id
      # Event.find(params[:id]).rsvp_form_id
    end

    def feedback_form_id
      # Event.find(params[:id]).feedback_form_id
    end
end
