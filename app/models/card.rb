class Card < ApplicationRecord
    mount_uploader :card_image, CardImageUploader
    belongs_to :user
    has_many :comments, dependent: :destroy

    validates :name, presence: true, length: { maximum: 255 }
    validates :remarks, presence: true, length: { maximum: 65_535 }
end
