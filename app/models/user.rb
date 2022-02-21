class User < ApplicationRecord
  belongs_to :location
  has_many :plants
  has_secure_password

  accepts_nested_attributes_for :location

  validates_associated :location
  validates :email, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP, message: "Invalid email address"}, uniqueness: { case_sensitive: true }
end
