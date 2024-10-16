require 'rails_helper'

RSpec.describe ContactsIndustriesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/contacts_industries').to route_to('contacts_industries#index')
    end

    it 'routes to #new' do
      expect(get: '/contacts_industries/new').to route_to('contacts_industries#new')
    end

    it 'routes to #show' do
      expect(get: '/contacts_industries/1').to route_to('contacts_industries#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/contacts_industries/1/edit').to route_to('contacts_industries#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/contacts_industries').to route_to('contacts_industries#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/contacts_industries/1').to route_to('contacts_industries#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/contacts_industries/1').to route_to('contacts_industries#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/contacts_industries/1').to route_to('contacts_industries#destroy', id: '1')
    end
  end
end
