class Card < ApplicationRecord
    mount_uploader :card_image, CardImageUploader

    belongs_to :user

    has_many :comments, dependent: :destroy

    validates :name, presence: true, length: { maximum: 255 }
    validates :remarks, presence: true, length: { maximum: 65_535 }

    before_validation :set_default_stock_quantity

  private

  def set_default_stock_quantity
    self.stock_quantity ||= 0 if stock_quantity.nil?
  end
end
