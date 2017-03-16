require 'rails_helper'
require 'carrierwave/test/matchers'

RSpec.describe AvatarUploader do
  include CarrierWave::Test::Matchers

  before do
    AvatarUploader.enable_processing = true
    @user = create(:user)
    @uploader = AvatarUploader.new(@user, Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'files', 'image.jpg')))
    @uploader.store!(File.open(File.join(Rails.root, 'spec', 'support', 'files', 'image.jpg')))
  end

  after do
    @uploader.remove!
    AvatarUploader.enable_processing = false
  end

  context 'the thumbnail version' do
    it 'scales down a landscape image to be exactly 120 by 120 pixels' do
      expect(@uploader.thumbnail).to have_dimensions(120, 120)
    end
  end

  context 'the square version' do
    it 'scales down a landscape image to fit within 400 by 400 pixels' do
      expect(@uploader.square).to be_no_larger_than(400, 400)
    end
  end

  it 'makes the image readable only to the owner and not executable' do
    expect(@uploader).to have_permissions(0644)
  end

  it 'has the correct format' do
    expect(@uploader).to be_format('JPEG')
  end
end
