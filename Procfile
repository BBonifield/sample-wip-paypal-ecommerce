web: bundle exec thin start -R config.ru -e $RAILS_ENV -p $PORT
worker: QUEUE=* VERBOSE=1 bundle exec rake resque:work
scheduler: VERBOSE=1 bundle exec rake resque:scheduler
