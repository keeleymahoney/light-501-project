require 'rails_helper'
require 'net/http'
require 'uri'

RSpec.describe 'Editing a form', type: :feature do
  scenario 'valid request' do
    event = Event.create!(name: 'Party', date: DateTime.now, description: 'The good party', location: 'My house')
    visit rsvp_form_event_path(event)

    click_on 'Create Form'
    event.reload
    link_string = 'https://docs.google.com/forms/d/' + event.rsvp_link + '/edit'
    visit rsvp_form_event_path(event)

    expect(page).to have_link('Edit In Google Forms', href: link_string)
  end
end
