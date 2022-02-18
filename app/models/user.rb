class User < ApplicationRecord
  belongs_to :location
  has_many :plants

  has_secure_password
  validates :email, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP, message: "Invalid email address"}, uniqueness: { case_sensitive: true }
end
