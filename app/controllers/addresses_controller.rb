class AddressesController < ApplicationController
  before_filter :require_login
  before_filter :load_address, :except => [:index]

  def index
    @addresses = current_user.addresses
  end

  def new
  end

  def create
    respond_to do |format|
      format.json {
        save_address_or_render_json_errors
      }
      format.html {
        save_address_or_render_template :new, 'Address has been created.'
      }
    end
  end

  def show
    respond_to do |format|
      format.json
    end
  end

  def edit
  end

  def update
    save_address_or_render_template :edit, 'Address has been updated.'
  end

  def destroy
    @address.destroy
    redirect_to addresses_path, :notice => 'Address has been deleted.'
  end


  private


  def save_address_or_render_json_errors
    @address.assign_attributes params[:address]

    if @address.save
      render :show
    else
      render :status => 400, :json => @address.errors.full_messages
    end
  end

  def save_address_or_render_template template, success_message
    @address.assign_attributes params[:address]

    if @address.save
      redirect_to addresses_path, :notice => success_message
    else
      render template
    end
  end

  def load_address
    if params[:id]
      @address = current_user.addresses.find params[:id]
    else
      @address = current_user.addresses.build
    end
  end
end
