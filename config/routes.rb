Capacitor::Application.routes.draw do
  devise_for :users
  resource :profile
  resources :charges
  root 'home#index'
end
