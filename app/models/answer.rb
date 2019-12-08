class Answer < ApplicationRecord
  include Votable

  default_scope -> { order(best: :desc, updated_at: :desc) }

  belongs_to :question
  belongs_to :user

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :best, uniqueness: { scope: :question_id }, if: :best?, presence: true
  validates :body, :score, presence: true

  scope :best, -> { where(best: true) }

  def set_best
    transaction do
      question.answers.best.update_all(best: false)
      update!(best: true)
      question.reward&.update!(user: user)
    end
  end
end
