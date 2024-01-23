class Card < ApplicationRecord
    mount_uploader :card_image, CardImageUploader
    belongs_to :user

    validates :name, presence: true, length: { maximum: 255 }
    validates :remarks, presence: true, length: { maximum: 65_535 }
end
