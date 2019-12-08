class LinksController < ApplicationController
  before_action :authenticate_user!

  expose :link

  def destroy
    @resource = link.linkable
    if current_user.author_of?(@resource)
      link.destroy
    end
  end

  private

  def attachment_params
    params.require(:link).permit(:id)
  end
end
