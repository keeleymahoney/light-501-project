require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe 'put :create_form' do
    it 'updates the rsvp_link' do
      event = Event.create(name: 'Party', date: DateTime.now, description: 'The good party', location: 'My house')

      expect(event.rsvp_link).to eq(nil)

      put :create_form, params: { id: event.id }

      event.reload

      expect(event.rsvp_link).not_to eq('')
      expect(event.rsvp_link).not_to eq(nil)
    end
  end
end
