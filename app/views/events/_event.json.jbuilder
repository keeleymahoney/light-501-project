# frozen_string_literal: true

json.extract! event, :id, :id, :name, :date, :datetime, :description, :location, :attendees, :created_at, :updated_at
json.url event_url(event, format: :json)
