require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
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
    resource :subscription, only: %i[create destroy], shallow: false
    resources :answers, concerns: %i[votable commentable], except: :index do
      patch :set_best, on: :member
    end
  end

  resource :attachment, only: :destroy
  resource :link, only: :destroy
  resources :rewards, only: :index

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        collection do
          get :me
          get :others
        end
      end
      resources :questions, only: %i[show index create update destroy], shallow: true do
        resources :answers, only: %i[show index create update destroy]
      end
    end
  end

  root to: 'questions#index'

  mount ActionCable.server => '/cable'
end
