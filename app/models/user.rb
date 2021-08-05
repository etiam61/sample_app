class User < ApplicationRecord
  USER_PARAMS = %i(name email password password_confirmation).freeze
  attr_accessor :remember_token, :activation_token
  before_save :downcase_email
  before_create :create_activation_digest
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

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private
  def downcase_email
    email.downcase!
  end
end
