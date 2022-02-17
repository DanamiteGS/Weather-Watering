class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, 
  format: {with: URI::MailTo::EMAIL_REGEXP, message: "Invalid email address"}, 
  uniqueness: { case_sensitive: true }
end
