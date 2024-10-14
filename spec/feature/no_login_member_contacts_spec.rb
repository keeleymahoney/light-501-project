require 'rails_helper'

RSpec.describe 'Managing network information', type: :feature do
    scenario 'error without logging in' do
        visit member_contacts_path
        expect(page).to have_content("You need to sign in or sign up before continuing.")
    end
end