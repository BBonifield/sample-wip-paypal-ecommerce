class AccountsController < ApplicationController
  before_filter :require_login

  def show
  end

  def edit
  end

  def update
    update_user_or_render_template :edit, "Your account has been updated."
  end

  def edit_password
  end

  def update_password
    if User.authenticate(current_user.user_name, params[:old_password])
      update_user_or_render_template :edit_password, "Your password has been changed."
    else
      flash[:error] = "Your old password was incorrect."
      render :edit_password
    end
  end


  private


  def update_user_or_render_template template, success_message
    current_user.assign_attributes params[:user]

    if current_user.save
      redirect_to account_path, :notice => success_message
    else
      render template
    end
  end

end
