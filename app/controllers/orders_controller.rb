class OrdersController < ApplicationController
  before_filter :authenticate_admin!, :except => [:show, :new, :create, :paypal]
  def index
    search_params = {:page => params[:page], :order => 'state DESC', :conditions => ["state != 'open'"]}
    search_params.merge!(:conditions => {:state => params[:state]}) if params[:state]
    @orders = Order.paginate(search_params)
  end
  
  def show
    @order = Order.find(params[:id])
  end
  
  def new
    @order = Order.new
  end
  
  def create
    @order = Order.new(params[:order])
    if @order.save
      flash[:notice] = "Successfully created order."
      redirect_to @order
    else
      render :action => 'new'
    end
  end
  
  def edit
    @order = Order.find(params[:id])
  end
  
  def update
    @order = Order.find(params[:id])
    if @order.update_attributes(params[:order])
      flash[:notice] = "Successfully updated order."
      redirect_to @order
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    flash[:notice] = "Successfully destroyed order."
    redirect_to orders_url
  end

  def paypal
    @order = Order.find(params[:id])
    @order.email = params[:email]
    if @order.save
      @order.ordered!
      redirect_to @order.paypal_url(products_url, notify_url(:secret => APP_CONFIG[:paypal_secret]))
    else
      flash[:error] = 'Please provide a valid email address'
      render :show
    end
  end

  def ship
    @order = Order.find(params[:id])
    @order.shipped!
  end
end
