# encoding: utf-8

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{model.id}"
  end

  process :resize_to_fit => [800, 800]

  version :index_thumb do
    process :resize_to_fit => [133,100]
  end

  version :form_thumb do
    process :resize_to_fit => [200,150]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
