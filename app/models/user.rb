class User < ApplicationRecord
  USER_PARAMS = %i(name email password password_confirmation).freeze
  attr_accessor :remember_token
  before_save :downcase_email

  validates :name, presence: true,
            length: {maximum: Settings.model.user.name.length.maximum}
  validates :email, presence: true,
            length: {maximum: Settings.model.user.email.length.maximum},
            format: {with: Settings.model.user.email.regex_valid},
            uniqueness: true
  validates :password, presence: true, allow_nil: true,
             length: {minimum: Settings.model.user.password.length.minimum}
  has_secure_password

  class << self
    def digest string
      min_cost = ActiveModel::SecurePassword.min_cost
      cost = min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    return false unless remember_token

    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  private
  def downcase_email
    email.downcase!
  end
end
