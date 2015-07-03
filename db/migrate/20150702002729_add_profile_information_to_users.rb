class AddProfileInformationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :blurb, :string
    add_column :users, :hobbies, :string
    add_column :users, :projects, :string
    add_column :users, :contact, :string
  end
end
