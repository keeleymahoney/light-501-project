class Member < ApplicationRecord
  devise :omniauthable, omniauth_providers: [:google_oauth2]
  has_one :token

  def self.from_google(email:, full_name:, uid:, avatar_url:)
    create_with(uid:, full_name:, avatar_url:).find_or_create_by!(email:)
  end
end
