if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['S3_KEY'],
      :aws_secret_access_key  => ENV['S3_SECRET']
    }
    config.fog_directory  = "clintsboard-#{Rails.env}"
    config.fog_public     = true
    config.permissions    = 0666

    # Needed for Heroku
    config.root      = Rails.root + '/tmp'
    config.cache_dir = 'carrierwave'
  end
end

