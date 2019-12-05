Rails.application.routes.draw do
  devise_for :users

  resources :questions, shallow: true do
    resources :answers, except: :index do
      patch :set_best, on: :member
    end
  end

  resource :attachment, only: :destroy
  resource :link, only: :destroy
  resources :rewards, only: :index

  root to: 'questions#index'
end
