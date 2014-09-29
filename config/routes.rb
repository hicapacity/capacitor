Capacitor::Application.routes.draw do
  devise_for :users
  resource :profile
  resources :charges
  resources :memberships
  root 'home#index'
end
