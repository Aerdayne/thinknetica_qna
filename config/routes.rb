Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      post :upvote
      post :downvote
    end
  end

  concern :commentable do
    member do
      resources :comments, only: :create
    end
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
