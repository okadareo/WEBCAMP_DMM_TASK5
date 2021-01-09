Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
  sessions: 'users/sessions' }

  root to: 'homes#top'
  get 'home/about' => 'homes#about'
  resources :users,only: [:show,:index,:edit,:update] do
    resource :relationships, only: [ :create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
  
  post 'search' => 'search#search', as: 'searching'
  
  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end
end