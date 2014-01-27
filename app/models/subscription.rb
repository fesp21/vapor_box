class Subscription < ActiveRecord::Base
  require "stripe"

  attr_accessible :address_id, :cost, :user_id, :token, :ship_date
  has_many :flavors_subscriptions
  has_many :flavors, through: :flavors_subscriptions


  has_one :plan_subscription
  has_one :plan, through: :plan_subscription

  has_many :accessories, through: :accessories_subscriptions
  has_many :accessories_subscriptions

  has_many :subscription_charges
  has_many :one_time_accessories
  belongs_to :address
  belongs_to :user
  
  def self.create_charge(cart, customer)
    plans = cart.select {|x| x['type']=='plan' }
    accessories = cart.select {|x| x['type']=='accessory' }
    flavors = cart.select {|x| x['type']=='flavor' }
    calculate_total(plans, accessories)
    
    Stripe::Charge.create(
      :amount => @total_charge,
      :currency => "usd",
      :customer => customer.id,
    )


  end

  def self.get_plan(cart)
    plan = cart.select {|x| x['type']=='plan' }
  end

  def self.create_stripe_customer(cart, token)
    #get plan unique ID
    plans = get_plan(cart)
    plan_id = "PL" + Plan.find(plans.first['id']).flavor_count.to_s


    # get UTC time trial ends
    start_date_time = DateTime.now

    if start_date_time > DateTime.now.beginning_of_month + 14.day
      start_date_time = (start_date_time + 2.month).beginning_of_month + 14.day
    else
      start_date_time = (start_date_time + 2.month).beginning_of_month
    end
    plan_cost = Plan.find(plans.first['id']).cost/100

    customer = Stripe::Customer.create(
      :description => "Customer",
      :card => token,
      :plan => plan_id,
      :quantity => plan_cost,
      :trial_end => start_date_time.utc.to_i
    )
    
  end

  def self.calculate_total(plans, accessories)
    plan_cost = plans.first['cost'].to_i
    accessories_cost = 0
    accessories.each { |accessory| accessories_cost = accessories_cost + accessory['cost'].to_i * accessory['quantity'].to_i }
    @total_charge =  plan_cost + accessories_cost
  end


end
