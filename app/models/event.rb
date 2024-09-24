# frozen_string_literal: true

class Event < ApplicationRecord
  validates :name, presence: true
  validates :date, presence: true
  validates :description, presence: true
  validates :location, presence: true
  has_many :event_images, dependent: :destroy
end
