class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :omniauthable, omniauth_providers: %i[auth0]
  
  mount_uploader :avatar, AvatarUploader

  has_many :cards, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :group_users
  has_many :groups, through: :group_users

  validates :password, length: { minimum: 3 }, if: :password_required?
  validates :password, confirmation: true, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?
  validates :email, uniqueness: true, allow_blank: true
  

  def own?(object)
    id == object.user_id
  end

  def password_required?
    provider.nil? || encrypted_password.blank?
  end

  def self.from_omniauth(auth)
    # binding.pry
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.password = Devise.friendly_token[0, 20]
      user.nickname = auth.info.nickname
    end
  end

  def email_required?
    false
  end
end
