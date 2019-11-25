class Answer < ApplicationRecord
  default_scope -> { order(best: :desc, updated_at: :desc) }

  belongs_to :question
  belongs_to :user

  validates :best, uniqueness: { scope: :question_id }, if: :best?
  validates :body, presence: true

  scope :best, -> { where(best: true) }

  def set_best
    question.answers.best.update(best: false)
    update!(best: true)
  end
end
