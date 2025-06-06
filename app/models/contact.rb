class Contact < ApplicationRecord
  validates :name, :email, :phone, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }
  validates :phone, format: { with: /\A\d{3}[\s\-]?\d{3}[\s\-]?\d{3}\z/, message: "must be a valid phone number" }
end
