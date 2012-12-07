class ApplicationController < ActionController::Base
  protect_from_forgery

  # when someone requests a non-existent id, present an error page
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found


  private


  def record_not_found
    render :text => "404 Not Found", :status => 404
  end

  def require_logged_out
    if logged_in?
      error_msg = I18n.t 'controllers.application.already_logged_in'
      redirect_to root_path, :flash => { :error => error_msg }
    end
  end

  def not_authenticated
    error_msg = I18n.t 'controllers.application.not_authenticated'
    redirect_to login_path, :flash => { :error => error_msg }
  end


  # Patching into sorcery's logic to prevent record not found exceptions
  # when a user has been deleted from the system but the end-user has a cookie
  # set indicating that they were logged in as that user.
  alias :sorcery_login_from_session :login_from_session
  def login_from_session
    sorcery_login_from_session
  rescue => exception
    return false if exception.is_a?(ActiveRecord::RecordNotFound)
    raise exception
  end

end
