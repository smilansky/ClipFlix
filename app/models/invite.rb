class Invite < ActiveRecord::Base
  belongs_to(:user)

  validates_presence_of :email, :name, :message
  before_create :generate_token

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end