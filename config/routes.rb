Rails.application.routes.draw do
  resources :events do
    resources :event_images, only: [:create, :destroy]
    member do
      get :delete
      get :rsvp_form
      get :create_form
      get :edit_form
      get :delete_form
    end
  end

  # put 'events/create_form'
  # get 'events/edit_form'
  # get 'events/respond_rsvp'
  # get 'forms/show_rsvp'

  # resources :forms do
  #   member do
  #     get 'show_rsvp'
  #     put 'create_form'
  #     get 'edit_form'

  #   end
  # end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
