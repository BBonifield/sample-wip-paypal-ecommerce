class UsersController < ApplicationController

  before_filter :require_logged_out

  def new
    @user = User.new
    @user.addresses.build
  end

  def create
    @user = User.new params[:user]

    mark_user_for_signup @user
    set_defaults_on_nested_address @user

    if @user.save
      auto_login @user
      redirect_to root_path, :notice => "Your account has been created!"
    else
      render :new
    end
  end


  private


  # specify that the user is signing up so the nested address is required
  def mark_user_for_signup user
    user.is_signing_up = true
  end

  # setup desired defaults for the address a user adds during signup
  def set_defaults_on_nested_address user
    address = user.addresses.first
    if address.present?
      address.name = "Primary Address"
      address.is_default_shipping = true
      address.is_default_billing = true
    end
  end

end
