require 'rails_helper'

RSpec.describe 'Deleting a form', type: :feature do
  scenario 'valid request' do
    event = Event.create!(name: 'Party', date: DateTime.now, description: 'The good party', location: 'My house')
    visit rsvp_form_event_path(event)

    click_on 'Create Form'
    visit rsvp_form_event_path(event)

    click_on 'Delete Form'
    visit rsvp_form_event_path(event)

    expect(page).not_to have_content('New Form')
    expect(page).not_to have_content('Submission Form')
    expect(page).not_to have_content('Edit In Google Forms')
    expect(page).not_to have_content('Delete Form')
    expect(page).to have_content('Create Form')
  end
end
