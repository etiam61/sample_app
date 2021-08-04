class User < ApplicationRecord
  before_save :downcase_email

  validates :name, presence: true,
            length: {maximum: Settings.model.user.name.length.maximum}
  validates :email, presence: true,
            length: {maximum: Settings.model.user.email.length.maximum},
            format: {with: Settings.model.user.email.regex_valid},
            uniqueness: true
  validates :password, presence: true,
             length: {minimum: Settings.model.user.password.length.minimum}
  has_secure_password

  private
  def downcase_email
    self.email = email.downcase
  end
end
