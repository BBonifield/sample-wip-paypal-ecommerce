class InventoryItemsController < ApplicationController
  before_filter :require_login
  before_filter :load_inventory_item, :except => :index

  def index
    @inventory_items = current_user.inventory_items

    # filter the items by a group
    if params[:inventory_group_id]
      @inventory_items = @inventory_items.where(:inventory_group_id => params[:inventory_group_id])
      @inventory_group = current_user.inventory_groups.find params[:inventory_group_id]
    end
  end

  def pending_delivery
    @inventory_items = current_user.inventory_items.pending_delivery
  end

  def new
  end

  def create
    save_inventory_item_or_render_template :new, "Inventory item has been created."
  end

  def edit
  end

  def update
    save_inventory_item_or_render_template :edit, "Inventory item has been updated."
  end

  def destroy
    @inventory_item.destroy
    redirect_to inventory_items_path, :notice => "Inventory item has been deleted."
  end

  def increment_quantity
    if @inventory_item.increment_quantity
      render :json => { :new_quantity => @inventory_item.quantity }
    else
      render 400
    end
  end

  def decrement_quantity
    if @inventory_item.decrement_quantity
      render :json => { :new_quantity => @inventory_item.quantity }
    else
      render 400
    end
  end


  protected


  def save_inventory_item_or_render_template template, success_message
    @inventory_item.assign_attributes params[:inventory_item]

    if @inventory_item.save
      redirect_to inventory_items_path, :notice => success_message
    else
      render template
    end
  end

  def load_inventory_item
    if params[:id]
      @inventory_item = current_user.inventory_items.find params[:id]
    else
      @inventory_item = current_user.inventory_items.build
    end
  end
end
