# frozen_string_literal: true
require 'carrierwave/processing/mini_magick'

class AvatarUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  process resize_to_fit: [800, 800]

  version :thumbnail do
    process resize_to_fill: [120, 120, 'Center']
  end

  version :square do
    process resize_to_fill: [400, 400, 'Center']
  end
end
