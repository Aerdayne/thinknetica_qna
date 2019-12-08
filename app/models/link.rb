class Link < ApplicationRecord
  URL_FORMAT = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?$/ix.freeze
  GIST_URL = /^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)(?:gist\.github)\.[a-z]{2,5}\/[a-zA-Z0-9]+\/[a-zA-Z0-9]+$/ix.freeze

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: URL_FORMAT, multiline: true, message: 'URL should be valid' }

  def url_is_gist?
    url =~ GIST_URL
  end
end