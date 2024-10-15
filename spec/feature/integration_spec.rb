# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Managing events', type: :feature do
  before do
    visit home_path
    click_on 'Login with Google'
  end
  scenario 'creating a new event with valid inputs' do
    visit new_event_path
    fill_in 'event[name]', with: 'spec event'
    fill_in 'event[location]', with: 'spec location'
    fill_in 'event[description]', with: 'spec description'

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

  scenario 'creating a new event with invalid inputs' do
    visit new_event_path
    fill_in 'event[location]', with: 'spec location'
    fill_in 'event[description]', with: 'spec description'

    # Select a date and time
    select '2024', from: 'event_date_1i'
    select 'September', from: 'event_date_2i'
    select '23', from: 'event_date_3i'
    select '12', from: 'event_date_4i'
    select '00', from: 'event_date_5i'


    click_on 'Create Event'
    expect(page).to have_content("Name can't be blank")
  end

  scenario 'editing an existing event' do
    # First, create the event
    event = Event.create!(name: 'spec event', location: 'spec location', description: 'spec description', date: DateTime.new(2024, 9, 23, 12))

    visit edit_event_path(event)

    # Edit the event details
    fill_in 'event[name]', with: 'updated event'
    fill_in 'event[location]', with: 'updated location'
    fill_in 'event[description]', with: 'updated description'

    click_on 'Update Event'

    # Verify that the event details were updated
    visit events_path
    expect(page).to have_content('updated event')
    expect(page).to have_content('updated location')
    expect(page).to have_content('updated description')
  end

  scenario 'editing an existing event without the name' do
    # First, create the event
    event = Event.create!(name: 'spec event', location: 'spec location', description: 'spec description', date: DateTime.new(2024, 9, 23, 12))

    visit edit_event_path(event)

    # Edit the event details
    fill_in 'event[name]', with: ''
    fill_in 'event[location]', with: 'updated location'
    fill_in 'event[description]', with: 'updated description'

    click_on 'Update Event'

    expect(page).to have_content("Name can't be blank")
  end

  scenario 'deleting an event' do
    # First, create the event
    event = Event.create!(name: 'spec event', location: 'spec location', description: 'spec description', date: DateTime.new(2024, 9, 23, 12))

    visit events_path
    expect(page).to have_content('spec event')

    # Delete the event
    visit delete_event_path(event)

    click_on 'Delete Event'

    # Verify that the event was deleted
    visit events_path
    expect(page).not_to have_content('spec event')
    expect(page).not_to have_content('spec location')
    expect(page).not_to have_content('spec description')
  end
end
