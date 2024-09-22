Rails.application.routes.draw do
  root 'forms#create'

  get 'forms/create'
  get 'forms/monitor'
  get 'forms/respond'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
