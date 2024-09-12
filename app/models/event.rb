class Event < ApplicationRecord
    validates :name, presence: true
    validates: date, presence: true
    validates: description, presence: true
    validates: location, presence: true
    validates: attendees, presence: true
end
