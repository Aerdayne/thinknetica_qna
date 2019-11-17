class Question < ApplicationRecord
  has_many :answers, dependent: :nullify

  validates :title, :body, presence: true
end
