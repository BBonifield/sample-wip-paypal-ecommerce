class InventoryGroupsController < ApplicationController
  before_filter :require_login

  def create
    @inventory_group = current_user.inventory_groups.build params[:inventory_group]

    if @inventory_group.save
      render :show
    else
      render :status => 400,
        :json => { :errors => @inventory_group.errors.full_messages }
    end
  end
end
