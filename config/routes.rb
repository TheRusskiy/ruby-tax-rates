Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'tax_rates#index'
  resources :tax_rates, only: [:show, :index] do
    collection do
      post :update_rates
    end
  end
end
