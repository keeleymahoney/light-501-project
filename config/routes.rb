# frozen_string_literal: true

Rails.application.routes.draw do
  # Set the root URL to the home#index action
  root 'home#index'

  # Devise routes for the Member model with Google OAuth callbacks
  devise_for :members, controllers: {
    omniauth_callbacks: 'members/omniauth_callbacks'
  }

  devise_scope :member do
    get 'members/sign_in', to: 'devise/sessions#new', as: :new_member_session
    get 'members/sign_out', to: 'devise/sessions#destroy', as: :destroy_member_session
  end

  # Home page route
  get 'home', to: 'home#index'
  
  # Media page route
  get 'media', to: 'home#media'

  # Featured page route
  get 'featured', to: 'home#featured'

  # About us page route
  get 'about', to: 'home#about'

  # Member dashboard route
  get 'dashboard', to: 'members/dashboard#show', as: :member_dashboard

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


  resources :member_contacts, only: [:index, :show]

  resources :member_networks, only: [:index, :edit]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  resources :contacts do
    member do
      get :delete
    end
  end

  resources :requests do
    member do
      get :delete
      post :approve
      post :deny 
    end
  end
end
