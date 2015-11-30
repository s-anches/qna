Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      patch 'like'
      patch 'dislike'
    end
  end

  resources :questions, concerns: :votable do
    resources :answers do
      patch 'set_best', on: :member
    end
  end
  root 'questions#index'
end
