Rails.application.routes.draw do
  get 'sessions/new'

  root 'posts#index'

  resources :posts do
    resources :tags#, only: [:destroy]
    resources :categories
    resources :file_uploads, only: [:new, :create, :destroy]
  end

  resources :users

  get   '/search'    => 'posts#search', :as => 'search_page'
  get   '/rate'    => 'posts#rate', :as => 'rate_page'

  get    'sign_in'   => 'sessions#new'
  post   'sign_in'   => 'sessions#create'
  delete 'sign_out'  => 'sessions#destroy'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # custom routes
  delete '/posts/:post_id/tags/:id', to: 'tag#destroy', as: 'destroy_post_tag_path'
  #get '/posts/:id', to: 'patients#show', as: 'patient'
end
