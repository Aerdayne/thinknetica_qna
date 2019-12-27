class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Reward, Link, Comment]
    can :update, [Question, Answer], user_id: user.id
    can :destroy, [Question, Answer, Comment], user_id: user.id

    can :set_best, Answer do |answer|
      user.author_of?(answer.question)
    end

    can :upvote, [Answer, Question] do |resource|
      !user.author_of?(resource)
    end

    can :downvote, [Answer, Question] do |resource|
      !user.author_of?(resource)
    end
  end
end