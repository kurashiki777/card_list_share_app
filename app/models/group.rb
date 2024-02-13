class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users
  mount_uploader :image, GroupImageUploader
  #before_create :generate_invitation_code
  before_create :generate_unique_invitation_code

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "image", "introduction", "invitation_code", "name", "owner_id", "updated_at"]
  end

  private

  def generate_unique_invitation_code
    loop do
      self.invitation_code = SecureRandom.hex(10)
      break unless Group.exists?(invitation_code: invitation_code)
    end
  end
end
