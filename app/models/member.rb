class Member < ApplicationRecord
  devise :omniauthable, omniauth_providers: [:google_oauth2]

  def self.from_google(email:, full_name:, uid:, avatar_url:, google_token:, token_exp_date:)
    create_with(uid: uid, full_name: full_name, avatar_url: avatar_url, google_token: google_token, token_exp_date: token_exp_date).find_or_create_by!(email: email)
  end
end
