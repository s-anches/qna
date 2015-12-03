Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      patch 'like'
      patch 'dislike'
      delete 'unvote'
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, concerns: :votable do
      patch 'set_best', on: :member
    end
  end
  root 'questions#index'
end
