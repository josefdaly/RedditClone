Rails.application.routes.draw do
  root to: 'subs#index'
  resource :session, only: [:create, :new, :destroy]
  resource :user, only: [:create, :new, :show]
  resources :subs, except: :destroy
  resources :posts, except: [:index, :destroy] do
    resources :comments, only: :new
  end
  resources :comments, only: [:create, :show]
end
