class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, order: :position

  has_secure_password

  validates :fullname, presence: true
  validates :password, presence: true, on: :create
  validates :email, presence: true, uniqueness: true
end