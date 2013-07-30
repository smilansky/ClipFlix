class User < ActiveRecord::Base
  has_many :reviews, order: "created_at DESC"
  has_many :queue_items, order: :position
  has_many :relationships
  has_many :leaders, through: :relationships
  has_many :following_relationships, class_name: "Relationship", foreign_key: :user_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id

  has_secure_password

  validates :fullname, presence: true
  validates :password, presence: true, on: :create
  validates :email, presence: true, uniqueness: true

  before_create :generate_token

  attr_acessible :token

  def normalize_queue_items
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

end

