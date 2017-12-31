Rails.application.routes.draw do
  resources :matchers, only: [:index]
  post 'cfpb_lookup', to: 'matchers#cfpb_lookup', as: 'cfpb_lookup'
  post 'exact_lookup', to: 'matchers#exact_lookup', as: 'exact_lookup'

  root 'matchers#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
