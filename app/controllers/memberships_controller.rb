class MembershipsController < ApplicationController
  def index

  end
  
  def show

  end
  
  def new
    
  end
  
  def create
    if (current_user.stripe_customer_id == nil)
      # user does not have an existing stripe id, create one
      exp_date = params[:expiration].split('/')
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
    
    puts params
    render :action => 'new'
    
  end
end
