class Member < ApplicationRecord
  # Devise OAuth settings
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  # Relationships
  has_one :contact, dependent: :destroy
  has_one :token

  # Validations
  validates :full_name, presence: true

  def self.from_google(email:, full_name:, admin: false)
    # Set default expiration to one day before today
    default_expiration = Date.yesterday

    # Find or create a Contact associated with the Member
    contact = Contact.find_or_create_by(email: email) do |c|
      c.first_name = full_name.split.first
      c.last_name = full_name.split.last
    end

    # Create or find the Member using the email and associate it with the contact
    member = find_or_create_by!(email: email) do |m|
      m.full_name = full_name
      m.admin = admin
      m.contact_id = contact.id  # Associate the contact with the member
      m.network_exp = default_expiration
      m.constitution_exp = default_expiration
    end

    member
  end
end
