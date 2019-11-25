Rails.application.routes.draw do
  devise_for :users

  resources :questions, shallow: true do
    resources :answers do
      patch :set_best, on: :member
    end
  end

  root to: 'questions#index'
end
