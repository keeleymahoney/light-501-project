require 'rails_helper'

RSpec.describe 'Creating a new event', type: :feature do
  scenario 'valid inputs' do
    visit new_event_path
    fill_in "event[name]", with: 'spec event'
    fill_in "event[location]", with: 'spec location'
    fill_in "event[description]", with: 'spec description'

    # Select a date and time
    select '2024', from: 'event_date_1i'
    select 'September', from: 'event_date_2i'
    select '23', from: 'event_date_3i'
    select '12', from: 'event_date_4i'
    select '00', from: 'event_date_5i'

    attach_file('event[images][]', Rails.root.join('spec/fixtures/files/BOLD_Logo.jpg'))

    click_on 'Create Event'
    visit events_path
    expect(page).to have_content('spec event')
    expect(page).to have_content('spec location')
    expect(page).to have_content('spec description')
    expect(page).to have_content('09/23/24 12:00 PM')
  end
end
