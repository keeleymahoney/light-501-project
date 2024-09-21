class Event < ApplicationRecord
    validates :name, presence: true
    validates :date, presence: true
    validates :description, presence: true
    validates :location, presence: true
    has_many :images, dependent: :destroy
end
