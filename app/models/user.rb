class User < ApplicationRecord

  has_many :course_users
  has_many :courses, through: :course_users
  has_many :tasks
  
  #Esta asosiacion es solo si la asosiacion es directa. En este caso es indirecta pues cuenta con un modelo intermedio
  #Por tal razon se utiliza has_many :course_users y has_many :users, through: :course_users
  #has_and_belongs_to_many :course_users #new


  #verificar los valores de maximum
  validates :names,  presence: true, length: { maximum: 50 }
  validates :lastnames,  presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 64 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  has_secure_password

  validates :password, presence: true, length: { maximum: 65 }, on: :create

  attr_accessor :reset_token,:rol

  def as_json options=nil
    options ||= {}
    options[:methods] = ((options[:methods] || []) + [:rol])
    super options
  end

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

   # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest,  User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end
end
