# frozen_string_literal: true

class Costume < ApplicationRecord
  validates :original_image_url, presence: true
  validates :title, presence: true
  validates :object_url, presence: true

  mount_uploader :picture, PictureUploader

  before_save :blank_to_nil
  before_validation :download_picture

  def self.import(object_id)
    costume = Costume.initialize_by_object_id(object_id)
    costume.save
  end

  def self.initialize_by_object_id(object_id)
    response = CostumeApiClient.return_json(object_id)
    Costume.new(
      object_id: response['objectID'],
      original_image_url: response['primaryImage'],
      title: response['title'],
      culture: response['culture'],
      country: response['country'],
      region: response['region'],
      object_url: response['objectURL'],
      date: response['objectDate']
    )
  end

  def self.initialize_by_title_url(title_url)
    response = CostumeApiClient.get_image_url(title_url)
    Costume.new(
      original_image_url: response.dig('query', 'pages', '-1', 'imageinfo')[0]['url'],
      title: response.dig('query', 'pages', '-1', 'title').delete('ファイル:'),
      object_url: response.dig('query', 'pages', '-1', 'imageinfo')[0]['descriptionurl']
    )
  end

  private

  def blank_to_nil
    self.title_japanese = nil if title_japanese.blank?
  end

  def download_picture
    return if picture.present?

    self.remote_picture_request_header = { 'Cookie' => 'incap_ses_637_1661977=c/kVUPxdLlTS2aSFBhXXCL2/YlwAAAAA90oj00SriHlKwXMQX45xkg==' }
    self.remote_picture_url = original_image_url
  end
end
