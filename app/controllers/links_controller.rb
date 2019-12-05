class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @link = Link.find(params[:id])
    if current_user.author_of?(@link.linkable)
      @link.destroy
    end
  end

  private

  def attachment_params
    params.require(:link).permit(:id)
  end
end
