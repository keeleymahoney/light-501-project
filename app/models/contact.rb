# frozen_string_literal: true

class Contact < ApplicationRecord
    
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
