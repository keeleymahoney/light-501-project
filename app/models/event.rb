# frozen_string_literal: true

class Event < ApplicationRecord
  validates :name, presence: true
  validates :date, presence: true
  validates :description, presence: true
  validates :location, presence: true

  has_many_attached :images

  before_destroy :purge_images

  validate :acceptable_images

  def acceptable_images
    return unless images.attached?
    images.each do |image|

      unless image.blob.byte_size <= 4.megabyte
        errors.add(:images, "is too big")
      end

      acceptable_types = ["image/jpeg", "image/png"]
      unless acceptable_types.include?(image.content_type)
        errors.add(:image, "must be a JPEG or PNG")
      end
    end
  end

  def purge_images
    images.purge_later
  end
end
