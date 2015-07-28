class User < ActiveRecord::Base
  belongs_to :role

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :first_name, presence: true, length: {maximum: 255}, on: :update
  validates :last_name, presence: true, length: {maximum: 255}, on: :update
  validates :email, presence: true, length: {maximum: 255}
  validates :contact,  length: {maximum: 255}

end
