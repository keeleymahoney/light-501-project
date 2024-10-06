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
      get :rsvp_form
      get :create_form
      get :delete_form
    end
  end


  resources :member_contacts do
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  resources :contacts do
    member do
      get :delete
    end
  end

end

