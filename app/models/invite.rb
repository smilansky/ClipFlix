class Invite < ActiveRecord::Base
  belongs_to(:user)

  before_create :generate_token

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end
end