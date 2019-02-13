CarrierWave.configure do |config|
  # config.storage :fog
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    provider: 'AWS',
    aws_access_key_id: ENV['AMAZON_ACCESS_KEY_ID'],
    aws_secret_access_key: ENV['AMAZON_SECRET_ACCESS_KEY'],
    region: 'ap-northeast-1'
  }

  config.fog_directory = ENV['S3_BUCKET_NAME']
  config.cache_storage = :fog
end
