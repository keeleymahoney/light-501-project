require 'rails_helper'

RSpec.describe 'OAuth Login', type: :request do

  # Sunny Day Scenario 1: Successful Google OAuth Redirection
  it 'redirects to Google for authentication' do
    get '/members/auth/google_oauth2'
    expect(response).to redirect_to(/accounts.google.com/)
  end

  # Sunny Day Scenario 2: Successful login and redirects to the root path
  it 'logs in the user and redirects to root path' do
    get '/members/auth/google_oauth2/callback'
    expect(response).to redirect_to(root_path)
    follow_redirect!
    expect(response.body).to include('Signed in successfully via Google.')
  end

  # Rainy Day Scenario 1: Invalid credentials should redirect to login
  it 'redirects to sign-in page on invalid credentials' do
    OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
    get '/members/auth/google_oauth2/callback'
    expect(response).to redirect_to(new_member_session_path)
    follow_redirect!
    expect(response.body).to include('You need to sign in or sign up before continuing.')
  end

  # Rainy Day Scenario 2: Invalid email domain
  it 'redirects to root path with alert if email domain is not tamu.edu' do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
      provider: 'google_oauth2',
      uid: '123545',
      info: {
        email: 'testuser@gmail.com',
        full_name: 'Test User',
        avatar_url: 'http://example.com/avatar.jpg'
      },
      credentials: {
        token: 'mock_token',
        refresh_token: 'mock_refresh_token',
        expires_at: Time.now + 1.week
      }
    })

    get '/members/auth/google_oauth2/callback'
    expect(response).to redirect_to(root_path)
    follow_redirect!
    expect(response.body).to include('You must use a tamu.edu email to sign in.')
  end
end
