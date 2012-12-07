RSpec.configure do |config|
  config.before do
    Resque.stub(:enqueue)
    Resque.stub(:enqueue_in)
    Resque.stub(:enqueue_at)
  end
end
