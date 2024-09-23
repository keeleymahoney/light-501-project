Rails.application.routes.draw do

  devise_for :members, controllers: { omniauth_callbacks: 'members/omniauth_callbacks' }

  resources :events do
    resources :event_images, only: [:create, :destroy]
    member do
      get :delete
      get :rsvp_form
      get :create_form
      get :delete_form
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
