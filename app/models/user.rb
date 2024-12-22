class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[line]

  mount_uploader :avatar, AvatarUploader

  has_many :cards, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :group_users
  has_many :groups, through: :group_users

  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:encrypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:encrypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:encrypted_password] }
  validates :email, uniqueness: true, presence: true, unless: :provider_omniauth?
  validates :name, presence: true, length: { maximum: 255 }

  def own?(object)
    id == object.user_id
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email.presence || "#{auth.uid}@line.com"
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
      user.password_confirmation = user.password # password_confirmationを設定
    end
  end
  # social_profilesの中身を順番に取り出して、指定したproviderと一致する最初のsocial_profileを返す
  def social_profile(provider)
    social_profiles.select { |sp| sp.provider == provider.to_s }.first
  end
	
	# omniauthから受け取った情報で、インスタンスの属性を設定する。
  def set_values(omniauth)
    # 既存の値と異なる場合、何もしない
    return if provider.to_s != omniauth["provider"].to_s || uid != omniauth["uid"]
  
    # 情報をインスタンスに適用
    credentials = omniauth["credentials"]
    info = omniauth["info"]
  
    # 各フィールドに値を設定（データベースにカラムが存在する場合）
    self.access_token = credentials["refresh_token"] if self.respond_to?(:access_token)
    self.access_secret = credentials["secret"] if self.respond_to?(:access_secret)
    self.credentials = credentials.to_json if self.respond_to?(:credentials)
    self.name = info["name"] if self.respond_to?(:name)
  end
	
	# 引数で受け取ったraw_infoをjson化してインスタンスのraw_infoに格納する
  def set_values_by_raw_info(raw_info)
    self.raw_info = raw_info.to_json
    self.save!
  end

  private

  def provider_omniauth?
    provider.present?
  end
end