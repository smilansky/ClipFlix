class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, order: :position

  has_secure_password

  validates :fullname, presence: true
  validates :password, presence: true, on: :create
  validates :email, presence: true, uniqueness: true

  def normalize_queue_items
    queue_items.each_with_index do |queue_item, index|
    queue_item.update_attributes(position: index + 1)
  end
end
end