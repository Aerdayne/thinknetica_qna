class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, presence: true, numericality: { less_than_or_equal_to: 1, greater_than_or_equal_to: -1, other_than: 0, only_integer: true }

  scope :upvotes, -> { where(value: 1) }
  scope :downvotes, -> { where(value: -1) }
end
