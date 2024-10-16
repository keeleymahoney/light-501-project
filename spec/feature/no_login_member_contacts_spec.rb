require 'rails_helper'

RSpec.describe 'Managing network information', type: :feature do
    scenario 'error without logging in' do
        visit member_contacts_path
        expect(page).to have_content("You do not have access to this page. Please log in.")
    end
end