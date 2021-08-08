class Micropost < ApplicationRecord
  MICROPOST_PARAMS = %i(content image).freeze
  belongs_to :user
  has_one_attached :image

  validates :user_id, presence: true
  validates :content, presence: true,
  length: {maximum: Settings.content.length.max}
  validates :image, content_type: {in: Settings.image.type},
  size: {less_than: Settings.image.size.megabytes}

  scope :newest, ->{order(created_at: :desc)}
  delegate :name, to: :user, prefix: true
end
