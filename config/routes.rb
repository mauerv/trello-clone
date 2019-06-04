Rails.application.routes.draw do
  resources :cards
  resources :lists
  root to: 'pages#home'
end
