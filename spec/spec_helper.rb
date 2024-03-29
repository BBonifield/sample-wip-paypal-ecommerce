require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'capybara/rails'
  require 'capybara/rspec'
  require 'database_cleaner'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # Define fixture path for fixture_file_upload
    config.fixture_path = "#{Rails.root}/spec/fixtures/"

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"

    # Before each test
    config.before(:each) do
      # Clean up the database
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.clean

      # Empty Action Mailer deliveries
      ActionMailer::Base.deliveries = []
    end

    # Include helpers to better test user auth functionality
    config.include AuthMacros, :type => :controller
    config.include AuthRequestMacros, :type => :feature

    # Allow develper to run single tests or scopes of tests with :focus => true
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run :focus => true
    config.run_all_when_everything_filtered = true
  end

end

Spork.each_run do
  # This code will be run each time you run your specs.

  # Reload all factories
  FactoryGirl.factories.clear
  FactoryGirl.find_definitions
end
