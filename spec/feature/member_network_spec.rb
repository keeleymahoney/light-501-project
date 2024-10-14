require 'rails_helper'

RSpec.describe 'Managing network information', type: :feature do
    before do
        visit events_path
        click_on 'Google'
    end

    scenario "viewing member path" do
        visit member_contacts_path
        expect(page).to have_content('Network Contacts')
    end

    scenario 'searching for contacts by first name' do

        member = Contact.create!(first_name: "test first name", last_name: "test last name", organization: "test org")

        visit member_contacts_path

        # Fill in the search form
        fill_in 'first_name', with: 'test'
        fill_in 'last_name', with: ''
        select '', from: 'organization'

        click_button 'Search'

        expect(page).to have_content('test first name')
    end

    scenario 'searching for contacts by last name' do

        member = Contact.create!(first_name: "test first name", last_name: "test last name", organization: "test org")

        visit member_contacts_path

        # Fill in the search form
        fill_in 'first_name', with: 'test'
        fill_in 'last_name', with: 'test last name'
        select '', from: 'organization'

        click_button 'Search'

        expect(page).to have_content('test last name')
    end

    scenario 'searching for contacts by organization' do

        member = Contact.create!(first_name: "test first name", last_name: "test last name", organization: "test org")

        visit member_contacts_path
    
        # Fill in the search form
        fill_in 'first_name', with: ''
        fill_in 'last_name', with: ''
        select 'test org', from: 'organization'
    
        click_button 'Search'
    
        expect(page).to have_content('test last name')
    end

    scenario 'searching for contacts by organization' do

        member = Contact.create!(first_name: "test first name", last_name: "test last name", organization: "test org")

        visit member_contacts_path
    
        # Fill in the search form
        fill_in 'first_name', with: 'should not pop up'
        fill_in 'last_name', with: ''
        select '', from: 'organization'
    
        click_button 'Search'
    
        expect(page).not_to have_content('test last name')
    end

    scenario 'view contact' do

        member = Contact.create!(first_name: "test first name", last_name: "test last name", organization: "test org")

        visit member_contact_path(member)
    
        expect(page).to have_content('test last name')
    end

    
end
