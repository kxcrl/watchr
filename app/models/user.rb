class User < ApplicationRecord
  before_create :generate_authentication_token

  has_secure_password

  has_many :favorites
  has_many :favorite_movies, through: :favorites, source: :movie

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create


  private

  def generate_authentication_token
    # Ensure that the token is truly unique, even if the chance of a duplicate
    # is very small
    loop do
      self.authentication_token = SecureRandom.hex(20)
      break unless User.exists?(authentication_token: authentication_token)
    end
  end
end
