class LinksController < ApplicationController
  before_action :authenticate_user!

  expose :link

  def destroy
    @resource = link.linkable
    authorize! :destroy, @resource

    link.destroy
  end
end
