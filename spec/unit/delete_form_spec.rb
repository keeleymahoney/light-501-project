require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe 'put :delete_form' do
    it 'deletes the rsvp_link' do
      event = Event.create(name: 'Party', date: DateTime.now, description: "The good party", location: "My house")

      put :create_form, params: { id: event.id }

      event.reload
      expect(event.rsvp_link).not_to eq('')
	  expect(event.rsvp_link).not_to eq(nil)

	  put :delete_form, params: { id: event.id }
	  
	  event.reload
      expect(event.rsvp_link).to eq('')
    end
  end
end