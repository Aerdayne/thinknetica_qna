Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      post :upvote
      post :downvote
    end
  end

  resources :questions, concerns: :votable, shallow: true do
    resources :answers, concerns: :votable, except: :index do
      patch :set_best, on: :member
    end
  end

  resource :attachment, only: :destroy
  resource :link, only: :destroy
  resources :rewards, only: :index

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
