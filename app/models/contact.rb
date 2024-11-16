# frozen_string_literal: true

class Contact < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true

  belongs_to :member, optional: true
  has_and_belongs_to_many :industries
  # has_one :request, dependent: :destroy

  has_one_attached :pfp

  before_update do
    contact = Contact.find_by(id:)
    contact.industries.clear
  end

  validate :acceptable_image

  private

  def acceptable_image
    
    if pfp.attached?
      # puts "#########&&&&&&&############&&&&&&###########&&&&&&&&########### Image content type: #{pfp.content_type}" 
      unless pfp.blob.byte_size <= 2.megabyte
        errors.add(:pfp, "is too big")
      end

      acceptable_types = ["image/jpeg", "image/png"]
      unless acceptable_types.include?(pfp.content_type)
        errors.add(:pfp, "must be a JPEG or PNG")
      end
    end
  end
  
end
