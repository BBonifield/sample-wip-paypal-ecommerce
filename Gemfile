source 'https://rubygems.org'

gem 'rails', '3.2.8'
gem 'sorcery'
gem 'haml-rails'
gem 'twitter_bootstrap_form_for',
  :git => 'https://github.com/stouset/twitter_bootstrap_form_for.git',
  :branch => 'bootstrap-2.0' # using 2.0 branch until it's final

gem 'carrierwave' # store file uploads
gem 'mini_magick' # process image file uploads
gem 'fog' # place file uploads on amazon s3

gem 'rabl' # JSON response templates
gem 'yajl-ruby' # RABL json parser

gem 'paypal_adaptive' # PayPal Payments

gem 'resque' # Background jobs
gem 'resque-scheduler', :require => 'resque_scheduler' # Scheduling background jobs


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'handlebars_assets' # javascript templates in asset pipeline
  gem "therubyracer" # required by less
  gem "less-rails" # required for less version of twitter bootstrap
  gem 'twitter-bootstrap-rails' # include twitter bootstrap

  gem 'uglifier', '>= 1.0.3'
end
gem 'jquery-rails'

# Local configuration
group :development do
  # User-friendly object printing
  gem 'awesome_print'

  # Use Guard + Addons for automated test runs
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'growl' # for guard notifications
  # gem 'listen', :git => "https://github.com/guard/listen.git", :tag => "v0.5.2" # fixes double test run issue
  gem 'rb-fsevent', :require => false # guard dependency for file changes
end
group :test, :development do
  gem 'sqlite3'

  # Various testing helpers
  gem 'rspec-rails', '~> 2.0'
  gem 'shoulda-matchers'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'capybara'

  # Pry for debug
  gem 'pry'
end

# Production configuration
group :production do
  # Use as the app server
  gem 'thin' , '1.3.1'
  # Use as the db server
  gem 'pg'
end
