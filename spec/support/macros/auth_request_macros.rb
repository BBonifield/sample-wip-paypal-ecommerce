module AuthRequestMacros
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

  end

  attr_accessor :current_user

  def login_user factory_params = {}
    factory_params[:email] = Faker::Internet.email unless factory_params.has_key? :email
    factory_params[:password] = 'somePassw0rd' unless factory_params.has_key? :password
    @current_user = FactoryGirl.create(:user, factory_params)

    visit login_path
    within '#session' do
      fill_in 'user_name_or_email', :with => factory_params[:email]
      fill_in 'Password', :with => factory_params[:password]
      click_on 'Sign In'
    end
  end

  def logout
    click_on 'Sign Out'
    @current_user = nil
  end

  def logged_in?
    @current_user.present?
  end

end
