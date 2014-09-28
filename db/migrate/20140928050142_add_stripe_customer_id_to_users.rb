class AddStripeCustomerIdToUsers < ActiveRecord::Migration
  def change    
    add_column :users, :stripe_customer_id, :string
    add_index :users, :stripe_customer_id, unique: true
  end
  
  def down
    remove_index :users, :stripe_cutsomer_id
    remove_column :users, :stripe_customer_id
  end
end
