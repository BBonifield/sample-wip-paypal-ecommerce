class SessionsController < ApplicationController
  before_filter :require_logged_out, :only => [:new, :create]
  before_filter :require_login, :only => [:destroy]

  def new
  end

  def create
    if login params[:user_name_or_email], params[:password]
      redirect_to root_path, :notice => "You are now logged in."
    else
      @login_failed = true
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path, :notice => "You are now logged out."
  end
end
