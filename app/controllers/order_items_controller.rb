class OrderItemsController < ApplicationController
  def index
    @order_items = OrderItem.all
  end
  
  def show
    @order_item = OrderItem.find(params[:id])
  end
  
  def new
    @order_item = OrderItem.new
  end
  
  def create
    @order_item = @order.order_items.find_or_initialize_by_product_id(params[:order_item])
    unless @order_item.new_record?
      @order_item.quantity += params[:order_item][:quantity].to_i
    end
    if @order_item.save
      redirect_to order_url(@order)
    else
      render :action => 'new'
    end
  end
  
  def edit
    @order_item = OrderItem.find(params[:id])
  end
  
  def update
    @order_item = OrderItem.find(params[:id])
    if @order_item.update_attributes(params[:order_item])
      flash[:notice] = "Successfully updated order item."
      redirect_to @order_item
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @order_item = OrderItem.find(params[:id])
    @order_item.destroy
    flash[:notice] = "Successfully destroyed order item."
    respond_to do |format|
      format.html { redirect_to order_url(@order) }
      format.js {}
    end
  end
end
