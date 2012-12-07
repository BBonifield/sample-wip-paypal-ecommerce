resque_config = YAML.load(ERB.new(File.new(Rails.root.to_s + '/config/resque.yml').read).result)
Resque.redis = resque_config[Rails.env]
