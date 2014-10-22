class MembershipsController < ApplicationController
  def index

  end
  
  def show

  end
  
  def new
    
  end
  
  def create
    begin
      exp_date = params[:expiration].split('/')
      if (current_user.stripe_customer_id == nil)
        # user does not have an existing stripe id, create one
        customer = Stripe::Customer.create(
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
        )
        current_user.stripe_customer_id = customer.id
        current_user.save
      else
        # user already had an existing stripe id, just reuse it
        customer = Stripe::Customer.retrieve(current_user.stripe_customer_id)
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
      render :show
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
      
      flash.now[:error] = err[:message]
      render action: 'new'
    end
  end
end
