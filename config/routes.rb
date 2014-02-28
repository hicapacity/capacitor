Capacitor::Application.routes.draw do
  devise_for :users
  resources :charges
  root 'home#index'
end
