# config/initializers/google_credentials.rb

# Initializer to create google api credentials file at runtime to protect credentials

require 'dotenv/load'
require 'json'

private_key = ENV['GOOGLE_PRIVATE_KEY'].gsub('\\n', "\n")

credentials = {
  type: 'service_account',
  project_id: ENV['GOOGLE_PROJECT_ID'],
  private_key_id: ENV['GOOGLE_PRIVATE_KEY_ID'].gsub('\\n', "\n"),
  private_key: private_key,
  client_email: ENV['GOOGLE_CLIENT_EMAIL'],
  client_id: ENV['GOOGLE_CLIENT_ID'],
  auth_uri: 'https://accounts.google.com/o/oauth2/auth',
  token_uri: 'https://oauth2.googleapis.com/token',
  auth_provider_x509_cert_url: 'https://www.googleapis.com/oauth2/v1/certs',
  client_x509_cert_url: ENV['GOOGLE_CLIENT_X509_CERT_URL']
}

File.write(Rails.root.join('config', 'google_credentials.json'), credentials.to_json)
