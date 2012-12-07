require 'spec_helper'
require 'carrierwave/test/matchers'

describe ImageUploader do
  include CarrierWave::Test::Matchers

  let(:inventory_item) { FactoryGirl.build_stubbed :inventory_item }

  before do
    ImageUploader.enable_processing = true
    @uploader = ImageUploader.new(inventory_item, :inventory_image)
    @uploader.store!(File.open("#{Rails.root}/spec/fixtures/files/test_image.jpg"))
  end

  after do
    ImageUploader.enable_processing = false
    @uploader.remove!
  end

  context 'the source version' do
    it "should scale down a landscape image to fit within 800 by 800 pixels" do
      @uploader.should be_no_larger_than(800, 800)
    end
  end

  context 'the index thumb version' do
    it "should scale down a landscape image to fit within 133 by 100 pixels" do
      @uploader.index_thumb.should be_no_larger_than(133, 100)
    end
  end

  context 'the form thumb version' do
    it "should scale down a landscape image to fit within 200 by 150 pixels" do
      @uploader.form_thumb.should be_no_larger_than(200, 150)
    end
  end
end
