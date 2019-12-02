class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @resource = @file.record
    @author = @resource.user
    if @author == current_user
      @file.purge
    end
  end

  private

  def attachment_params
    params.require(:attachment).permit(:id)
  end
end
