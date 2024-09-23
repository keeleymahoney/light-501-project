# frozen_string_literal: true

Rails.application.routes.draw do
  resources :events do
    resources :event_images, only: %i[create destroy]
    member do
      get :delete
      get :rsvp_form
      get :create_form
      get :delete_form
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  resources :contacts do
    member do
      get :delete
    end
  end

  root 'events#index'
end
