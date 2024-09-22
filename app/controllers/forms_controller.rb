class FormsController < ApplicationController

  def create
  end

  def monitor
    require 'google/apis/forms_v1'

    forms = Google::Apis::FormsV1::FormsService.new

    scopes = ['https://www.googleapis.com/auth/forms.responses.readonly']
    forms.authorization = Google::Auth.get_application_default(scopes)

    # @curr_form = forms.get_form(formId='1RJfBCqaPYto6HBo-Z_BzHSGF-q-cLoROwMM3MhsvXt8')
    @curr_form = forms.list_form_responses(formId='1RJfBCqaPYto6HBo-Z_BzHSGF-q-cLoROwMM3MhsvXt8')
    # @rsvp_link = Event.find(params[:id]).rsvp_link
    # @rsvp_link = ""
  end

  def respond
  end
end
