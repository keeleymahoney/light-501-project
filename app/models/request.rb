class Request < ApplicationRecord
  belongs_to :member
  belongs_to :contact, optional: true, dependent: :destroy

  # accepts_nested_attributes_for :contact

  enum :request_type, %i[network_access constitution_access network_addition]
  enum :status, %i[unsettled accepted rejected]

  before_destroy :destroy_contact

  private

  def destroy_contact
    contact.destroy if contact.present?
  end
end
