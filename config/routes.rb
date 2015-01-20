Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'
  #
  # get '/login', to: 'sessions#new'

  post '/login', to: 'sessions#create'

  post '/logout', to: 'sessions#destroy', as: 'logout'

   get  '/admin',  to: 'users#admin', as: 'admin'


  resources :users, :ideas, :categories, :images
  # get 'sessions#new'

end
