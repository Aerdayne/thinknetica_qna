class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @resource = @file.record
    authorize! :destroy, @resource

    @file.purge
  end
end
