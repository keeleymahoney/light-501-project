# frozen_string_literal: true

class Contact < ApplicationRecord
  has_and_belongs_to_many :industries

  before_update do
    contact = Contact.find_by(id: self.id)
    contact.industries.clear
  end

end
