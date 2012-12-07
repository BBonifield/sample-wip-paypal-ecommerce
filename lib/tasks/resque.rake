require 'resque/tasks'
require 'resque_scheduler/tasks'

# require the rails environment for tasks
task "resque:setup" => :environment
