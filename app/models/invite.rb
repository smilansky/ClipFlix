class Invite < ActiveRecord::Base
  include Tokenable

  belongs_to(:user)

  validates_presence_of :email, :name, :message
  before_create :generate_token

end