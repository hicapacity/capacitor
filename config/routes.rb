Capacitor::Application.routes.draw do
  devise_for :users
  resource :profile
  resources :profiles
  resources :charges
  resource :membership
  root 'home#index'
end
