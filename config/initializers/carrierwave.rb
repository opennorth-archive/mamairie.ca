CarrierWave.configure do |config|
  # To serve uploads in development, we must store files in the "public" directory.
  config.root = Rails.root.join(Rails.env.production? ? 'tmp' : 'public')
  config.cache_dir = 'uploads'
  if Rails.env.production?
    config.fog_credentials = {
      :provider => 'AWS',
      :aws_access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
    }
    config.fog_directory = ENV['AWS_DIRECTORY']
    config.fog_host = '//' + ENV['AWS_DIRECTORY']
    config.storage = :fog
  else
    config.storage = :file
  end
end
