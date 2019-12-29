class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :rewards, dependent: :nullify
  has_many :votes, dependent: :nullify
  has_many :comments, dependent: :nullify
  has_many :subscriptions, dependent: :destroy

  def author_of?(record)
    record.user_id == id
  end

  def find_subscription(question)
    subscriptions.where(question_id: question.id).first
  end
end
