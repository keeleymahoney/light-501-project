# frozen_string_literal: true

FactoryBot.define do
  factory :event_image do
    association :event
    picture { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/BOLD_Logo.jpg'), 'image/jpeg') }
  end
end
