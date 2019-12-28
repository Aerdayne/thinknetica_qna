Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users

  concern :votable do
    member do
      post :upvote
      post :downvote
    end
  end

  concern :commentable do
    resources :comments, only: %i[create destroy]
  end

  resources :questions, concerns: %i[votable commentable], shallow: true do
    resources :answers, concerns: %i[votable commentable], except: :index do
      patch :set_best, on: :member
    end
  end

  resource :attachment, only: :destroy
  resource :link, only: :destroy
  resources :rewards, only: :index

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
