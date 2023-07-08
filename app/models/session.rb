class Session < ApplicationRecord
  belongs_to :user

  before_create :generate_token

  validates :user, presence: true

  private

  def generate_token
    self.token = SecureRandom.base58(24)
  end
end
