# Helper to load seed yaml into an object
def load_seed_yaml classification
  YAML.load File.read( "#{ Rails.root }/db/seeds/models/#{ classification.to_s }.yml" )
end

# Helper to populate an instance from seed data, bypassing
# attr_accessible logic
def populate_instance inst, data
  data.each_pair do |key, value|
    inst.send "#{key}=".to_sym, value
  end
end


# Seed users
User.destroy_all
load_seed_yaml(:users).each do |user_data|
  user = User.new
  populate_instance user, user_data
  user.password_confirmation = user.password
  user.save!
end

# Seed categories
Category.destroy_all
load_seed_yaml(:categories).each do |category_data|
  category = Category.new
  populate_instance category, category_data
  category.save!
end

# Seed conditions
Condition.destroy_all
load_seed_yaml(:conditions).each do |condition_data|
  condition = Condition.new
  populate_instance condition, condition_data
  condition.save!
end

# Seed shipping speeds
ShippingSpeed.destroy_all
load_seed_yaml(:shipping_speeds).each do |shipping_speed_data|
  shipping_speed = ShippingSpeed.new
  populate_instance shipping_speed, shipping_speed_data
  shipping_speed.save!
end

# Seed shipping services
ShippingService.destroy_all
load_seed_yaml(:shipping_services).each do |shipping_service_data|
  shipping_service = ShippingService.new
  populate_instance shipping_service, shipping_service_data
  shipping_service.save!
end
