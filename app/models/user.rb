class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true,
                   format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, if: -> { new_record? || password.present? }

  before_save :downcase_email
  before_create :generate_remember_token

  def admin?
    admin
  end

  private

  def downcase_email
    self.email = email.downcase
  end

  def generate_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end 