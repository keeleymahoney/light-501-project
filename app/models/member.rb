class Member < ApplicationRecord
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  # Add validation for TAMU email domain
  validate :validate_tamu_email

  def self.from_google(email:, name:, uid:, image:)
    create_with(name: name, image: image).find_or_create_by!(email: email)
  end

  private

  # Custom method to validate email domain
  def validate_tamu_email
    unless email.ends_with?('@tamu.edu')
      errors.add(:email, "must be a TAMU email (ending in @tamu.edu)")
    end
  end
end
