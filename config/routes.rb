Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  resources :contacts do
     member do
      get :delete
    end
  end

  root "contacts#index"
end
