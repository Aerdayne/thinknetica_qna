Rails.application.routes.draw do
  devise_for :users

  resources :questions, shallow: true do
    delete :destroy_attachment, on: :member
    resources :answers, except: :index do
      patch :set_best, on: :member
      delete :destroy_attachment, on: :member
    end
  end

  root to: 'questions#index'
end
