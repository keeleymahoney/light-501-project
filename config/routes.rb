# frozen_string_literal: true

Rails.application.routes.draw do
  root "events#index"

  # Devise routes for the Member model with Google OAuth callbacks
  devise_for :members, controllers: {
    omniauth_callbacks: 'members/omniauth_callbacks'
  }

  devise_scope :member do
    get 'members/sign_in', to: 'devise/sessions#new', as: :new_member_session
    get 'members/sign_out', to: 'devise/sessions#destroy', as: :destroy_member_session
  end

  resources :events do
    resources :event_images, only: %i[create destroy]
    member do
      get :delete
      get :sign_in_form
      get :show_rsvp_form
      get :create_rsvp_form
      get :delete_rsvp_form
      get :destroy_rsvp_form
      get :show_feedback_form
      get :create_feedback_form
      get :delete_feedback_form
      get :destroy_feedback_form      
    end
  end

  resources :contacts do
    member do
      get :delete
    end
  end
end

