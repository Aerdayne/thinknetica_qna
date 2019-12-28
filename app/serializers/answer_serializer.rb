class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :best, :score
  belongs_to :question
  has_many :comments
  has_many :links
  has_many :files
  belongs_to :user

  def files
    object.files.map do |file|
      { url: Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true) }
    end
  end
end