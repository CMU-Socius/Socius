Rails.application.routes.draw do

  resources :alliances
  # Routes for main resources
  resources :organizations
  resources :users
  resources :needs
  resources :posts
  resources :sessions

  # Semi-static page routes
  get 'home' => 'home#home', as: :home
  get 'about' => 'home#about', as: :about
  get 'privacy' => 'home#privacy', as: :privacy

  get 'user/edit' => 'users#edit', :as => :edit_current_user
  get 'signup' => 'users#new', :as => :signup
  get 'login' => 'sessions#new', :as => :login
  get 'logout' => 'sessions#destroy', :as => :logout


  #Set the root url
  root :to => 'home#home'
end
