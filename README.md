# WIP

WIP is an ecommerce platform that essentially reverses eBay.
Instead of buyers looking for people that are seeling items they want,
WIP's aim is to help sellers to find buyers that are interested
in purchasing items.

## Getting Started

1. Get Ruby 1.9.2 installed, ensuring that the bundler gem is installed
   as well.
2. In the project directory, type `bundle install` to install all
   gems used in the project.
    - There are a few system dependencies that you may or may not need
      to install depending on your system.  Common ones are listed below:
        * **ImageMagick** -- image processing
        * **Redis** -- key/value data store for Resque
        * **Postgres** -- database server
3. To get running in development mode, you need to start the web server,
   a job worker, and the job scheduler.
    - To start thin (web server): `bundle exec rails server`
    - To start Resque (job worker): `QUEUE=* bundle exec rake resque:work`
    - To start ResqueScheduler (job scheduler): `bundle exec rake resque:scheduler`
    - *NOTE:* There is a pretty good chance you will also need to setup
      a tunneling service so that PayPal IPN notifications get sent back
      to localhost properly.  Recommend ForwardHQ.

## Environment Variables

`Note:` In development, you can create a .env file in your project
directory and setup your shell to source that file when you switch into
the directory.  In production, these variables are set as Heroku
configuration variables (e.g. heroku config add)

* `S3_KEY` -- Amazon S3 Access Key ID
* `S3_SECRET` -- Amazon S3 Secret Access Key
* `PAYPAL_FEES_EMAIL` -- PayPal account email that site monetization fees
  should be transferred into.
* `PAYPAL_API_USERNAME` -- PayPal API User Name
* `PAYPAL_API_PASSWORD` -- PayPal API Password
* `PAYPAL_API_SIGNATURE` -- PayPal Signature
* `PAYPAL_APPLICATION_ID` -- PayPal Application ID (Always use
  'APP-80W284485P519543T' in development or test)
* `SENDGRID_USERNAME` -- SendGrid Username
* `SENDGRID_PASSWORD` -- SendGrid Password

### Production Specific Environment Variables

* `REDISTOGO_URL` -- The redis:// URL to connect to in production

### Development Specific Environment Variables

* `CALLBACK_TUNNEL_HOST` -- Tunnel hostname to use to route callbacks back
  to localhost (e.g. PayPal notifications, using ForwardHQ to route the
  notifications)
