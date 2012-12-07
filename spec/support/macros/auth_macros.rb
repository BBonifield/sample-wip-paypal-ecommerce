module AuthMacros
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def it_should_require_logged_out_for_action *action_and_params
      self.it_should_require_logged_out_for_actions(*action_and_params)
    end

    # ex: it_should_require_logged_out_for_actions :index, :show
    #     it_should_require_logged_out_for_actions :index, :show, :some_id => 1
    def it_should_require_logged_out_for_actions *actions_and_params
      # extract custom action params if the last argument is a hash,
      # for instance, if another key is necessary to test the route
      action_params = { :id => 1 }
      if actions_and_params.last.instance_of? Hash
        action_params.merge! actions_and_params.pop
      end

      actions_and_params.each do |action|
        it "#{action} action should require logged out" do
          login_user
          get action, action_params
          response.should redirect_to root_path
          flash[:error].should eq I18n.t('controllers.application.already_logged_in')
        end
      end
    end


    def it_should_require_login_for_action *action_and_params
      self.it_should_require_login_for_actions(*action_and_params)
    end

    # ex: it_should_require_login_for_actions :index, :show
    #     it_should_require_login_for_actions :index, :show, :some_id => 1
    def it_should_require_login_for_actions *actions_and_params
      # extract custom action params if the last argument is a hash,
      # for instance, if another key is necessary to test the route
      action_params = { :id => 1 }
      if actions_and_params.last.instance_of? Hash
        action_params.merge! actions_and_params.pop
      end

      actions_and_params.each do |action|
        it "#{action} action should require logged in" do
          logout if logged_in?
          get action, action_params
          response.should redirect_to login_path
          flash[:error].should eq I18n.t('controllers.application.not_authenticated')
        end
      end
    end
  end

  attr_accessor :current_user

  def login_user factory_params = {}
    auto_login FactoryGirl.create(:user, factory_params)
    @current_user
  end

  def logout
    @current_user = nil
    @controller.logout
  end

  def logged_in?
    @current_user.present?
  end

  protected

  def auto_login user
    @current_user = user
    @controller.auto_login user
  end
end
