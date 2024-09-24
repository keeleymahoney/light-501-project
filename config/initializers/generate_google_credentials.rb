# config/initializers/google_credentials.rb

# Initializer to create google api credentials file at runtime to protect credentials

require 'dotenv/load'
require 'json'

private_key = Rails.application.credentials.service_credentials[:google_private_key].gsub('\\n', "\n")

credentials = {
  type: 'service_account',
  project_id: Rails.application.credentials.service_credentials[:google_project_id],
  private_key_id: Rails.application.credentials.service_credentials[:google_private_key_id],
  private_key: private_key,
  client_email: Rails.application.credentials.service_credentials[:google_client_email],
  client_id: Rails.application.credentials.service_credentials[:google_client_id],
  auth_uri: 'https://accounts.google.com/o/oauth2/auth',
  token_uri: 'https://oauth2.googleapis.com/token',
  auth_provider_x509_cert_url: 'https://www.googleapis.com/oauth2/v1/certs',
  client_x509_cert_url: Rails.application.credentials.service_credentials[:google_client_x509_cert_url]
}

File.write(Rails.root.join('config', 'google_credentials.json'), credentials.to_json)