# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  session_token   :string           not null
#  username        :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ActiveRecord::Base
  validates :username, :password_digest, :session_token, presence: true
  validates :username, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }

  has_many :subs, foreign_key: :moderator_id
  has_many :posts, foreign_key: :author_id

  after_initialize :ensure_session_token

  attr_reader :password

  def self.find_by_credentials(credentials)
    user = User.find_by(username: credentials[:username])
    user if user && user.is_password?(credentials[:password])
  end

  def password=(password)
    self.password_digest = BCrypt::Password.create(password)
    @password = password
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    save
    session_token
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end
end
