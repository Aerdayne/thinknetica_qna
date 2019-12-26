class RewardsController < ApplicationController
  before_action :authenticate_user!

  expose :rewards, -> { current_user.rewards }

  authorize_resource
end
