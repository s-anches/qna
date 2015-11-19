Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers do
      patch 'set_best', on: :member
    end
  end
  root "questions#index"
end
