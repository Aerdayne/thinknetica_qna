class Reward < ApplicationRecord
  belongs_to :question
  belongs_to :user, required: false

  has_one_attached :file

  validates :name, :file, presence: true
end
