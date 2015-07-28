class AddProfileInformationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :blurb, :text
    add_column :users, :hobbies, :text
    add_column :users, :projects, :text
    add_column :users, :contact, :string
    add_column :users, :public, :boolean
  end
end
