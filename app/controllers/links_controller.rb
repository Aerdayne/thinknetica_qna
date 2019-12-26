class LinksController < ApplicationController
  before_action :authenticate_user!

  expose :link

  def destroy
    @resource = link.linkable
    authorize! :destroy, @resource

    link.destroy
  end

  private

  def attachment_params
    params.require(:link).permit(:id)
  end
end
