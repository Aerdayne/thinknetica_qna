class Question < ApplicationRecord
  include Votable
  include Commentable

  belongs_to :user

  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many :subscriptions, dependent: :destroy

  has_one :reward, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, :score, presence: true

  def subscribe(user)
    subscriptions.create!(user_id: user.id)
  end

  def unsubscribe(user)
    subscriptions.where(user_id: user.id).delete_all
  end
end
