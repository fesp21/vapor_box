class SubscriptionsController < ApplicationController
  
  def index
    @subscriptions = Subscription.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @subscriptions }
    end
  end

  def show
    @subscription = Subscription.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @subscription }
    end
  end

  def new
    @subscription = Subscription.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @subscription }
    end
  end


  def edit
    @subscription = Subscription.find(params[:id])
  end


  def create
    
    @cart = JSON.parse params[:cart]
    @token = params[:token]
    @user = User.find(params[:userId])
    @address = Address.find(params[:addressId])
    #date.time now to determine ship date 15 or 1
    @customer = Subscription.create_stripe_customer @cart, @token
    Subscription.create_charge @cart, @customer

    #determine ship date
    start_date_time = DateTime.now
    if start_date_time > DateTime.now.beginning_of_month + 14.day
      @ship_date = 15
    else
      @ship_date = 1
    end
    binding.pry
    @subscription = Subscription.new(user_id: @user.id, address_id: @address.id, customer_stripe: @customer.id, ship_date: @ship_date)

        # process sub
        # plans/sub
        # flaovrs/sub
        # one time accessory
        # one time charge

        # create charge
        # create sub w delayed date

    respond_to do |format|
      if @subscription.save
        #update flav join table
        #update acc join table
        #update plans join table
        #update address user/sub
        format.html { redirect_to @subscription, notice: 'Subscription was successfully created.' }
        format.json { render json: @subscription, status: :created, location: @subscription }
      else
        format.html { render action: "new" }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @subscription = Subscription.find(params[:id])

    respond_to do |format|
      if @subscription.update_attributes(params[:subscription])
        format.html { redirect_to @subscription, notice: 'Subscription was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @subscription.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy

    respond_to do |format|
      format.html { redirect_to subscriptions_url }
      format.json { head :no_content }
    end
  end
end
