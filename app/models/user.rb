class User < ApplicationRecord
  has_secure_password
  has_secure_token :auth_token

  has_many :contacts, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }

  def regenerate_auth_token
    update(auth_token: self.class.generate_unique_secure_token)
  end
end
