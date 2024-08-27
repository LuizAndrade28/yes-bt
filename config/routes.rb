Rails.application.routes.draw do
  root to: "pages#home"
  get "up" => "rails/health#show", as: :rails_health_check

  resources :players, only: [:new, :create, :edit, :update, :destroy]
  resources :matches do
    resources :plays, only: [:new, :create, :edit, :update, :destroy] do
      resources :play_players, only: [:new, :create, :edit, :update, :destroy]
    end
  end
end
