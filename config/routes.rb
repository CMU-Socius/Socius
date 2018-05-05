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

  # AJAX Routes
  get 'claim_request' => 'posts#claim', :as => :claim_request
  get 'unclaim_request' => 'posts#unclaim', :as => :unclaim_request
  get 'cancel_request' => 'posts#cancel', :as => :cancel_request
  get 'update_needs' => 'posts#update_needs', :as => :update_needs
  get 'complete_post_need' => 'post_needs#complete', :as => :complete_post_need
  get 'undo_complete_post_need' => 'post_needs#undo_complete', :as => :undo_complete_post_need

  #Set the root url
  root :to => 'home#home'
  get '*any', via: :all, to: 'application#page_not_found'
end
