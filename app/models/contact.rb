# frozen_string_literal: true

class Contact < ApplicationRecord
  # validates :first_name, presence: true
  # validates :last_name, presence: true
  # validates :organization, presence: true
  # validates :title, presence: true
  # validates :email, presence: true
  # validates :bio, presence: true
  belongs_to :member, optional: true
  has_and_belongs_to_many :industries

  before_update do
    contact = Contact.find_by(id:)
    contact.industries.clear
  end

  def pfp_file=(file)
    self.pfp = file.read
  end

  def pfp_file
    StringIO.new(pfp) if pfp
  end
  
end
