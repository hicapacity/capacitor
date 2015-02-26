class MembershipsController < ApplicationController
  def index

  end
  
  def show
    begin
      if (current_user.stripe_customer_id)
        @plan_amount = nil;
        customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
        subscriptions = customer.subscriptions.all(:limit => 1)
        if (subscriptions.data.any?)
          subscription = subscriptions.data[0]
          plan = subscription.plan
          @plan_amount = plan.amount/100
          @plan_interval = plan.interval
          @plan_name = plan.name
        
          discount = customer.discount
          if discount
            coupon = discount.coupon
            @coupon_name = coupon.id
            percent_off = coupon.percent_off
            amount_off = coupon.amount_off / 100
          
            puts coupon
        
            if percent_off
              @plan_amount -= @plan_amount * percent_off / 100
            elsif amount_off
              @plan_amount -= amount_off
            end
          end
        end
      end
    rescue Stripe::InvalidRequestError
      # Code made a bad call
      flash[:error] = "An unexpected error occurred. Please notify an administrator."
      render :new
    rescue Stripe::ApiError
      # Stripe servers are having a problem
      flash[:error] = "Stripe is having an issue. Please try again."
      render :new
    end
  end
  
  def new
    
  end
  
  def create
    begin
      # if they have entered a coupon code, validate it now
      coupon = nil
      # customer_info[:coupon] = params[:couponCode] unless params[:couponCode].empty?
      unless params[:couponCode].empty?
        begin
          coupon = Stripe::Coupon.retrieve(params[:couponCode])
        rescue => e
          # coupon was invalid
          
          body = e.json_body
          err  = body[:error]
          
          flash[:error] = err[:message]
          render :new
          return
        end
      end
      
      exp_date = params[:expiration].split('/')

      if (current_user.stripe_customer_id == nil)
        # user does not have an existing stripe id, create one
        customer_info = {
          :description => "",
          :card => {
            :number => params[:cardNumber],
            :exp_month => exp_date[0],
            :exp_year => exp_date[1],
            :cvc => params[:cvc],
            :name => params[:cardholderName]
          },
          :email => current_user.email,
          :plan => params[:plan]
        }
        
        # add coupon code
        if coupon
          customer_info[:coupon] = coupon.id
        end
        
        customer = Stripe::Customer.create(customer_info)
        
        current_user.stripe_customer_id = customer.id
        current_user.save
      else
        # user already had an existing stripe id, just reuse it
        customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
        
        # set the coupon first so that it applies to the first invoice
        if coupon
          customer.coupon = coupon.id
          customer.save
        end
        
        customer.subscriptions.create(
          :plan => params[:plan],
          :card => {
            :number => params[:cardNumber],
            :exp_month => exp_date[0],
            :exp_year => exp_date[1],
            :cvc => params[:cvc],
            :name => params[:cardholderName]
          }
        )
        
      end
      redirect_to action: :show
    rescue Stripe::CardError => e
      # Since it's a decline, Stripe::CardError will be caught
      body = e.json_body
      err  = body[:error]

      puts "Status is: #{e.http_status}"
      puts "Type is: #{err[:type]}"
      puts "Code is: #{err[:code]}"
      # param is '' in this case
      puts "Param is: #{err[:param]}"
      puts "Message is: #{err[:message]}"
      
      flash[:error] = err[:message]
      render :new
    rescue Stripe::InvalidRequestError
      # Code made a bad call
      flash[:error] = "An unexpected error occurred. Please notify an administrator."
      render :new
    end
    rescue Stripe::ApiError
      # Stripe servers are having a problem
      flash[:error] = "Stripe is having an issue. Please try again."
      render :new
  end
  
  def destroy
    customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
    subscriptions = Stripe::Customer.retrieve(current_user.stripe_customer_id).subscriptions.all(:limit => 1)
    if (subscriptions.data.any?)
      subscription = subscriptions.data[0]
      subscription.delete
    end
    redirect_to action: :show
  end
end
