require 'rails_helper'
require 'net/http'
require 'uri'

RSpec.describe 'Editing a form', type: :feature do
  scenario 'valid request' do
    event = Event.create!(name: 'Party', date: DateTime.now, description: 'The good party', location: 'My house')
    visit rsvp_form_event_path(event)

    click_on 'Create Form'
    event.reload
    visit rsvp_form_event_path(event)

    expect(page).to have_link('Submission Form')
  end
end
