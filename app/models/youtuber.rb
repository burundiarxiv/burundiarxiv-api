class Youtuber < ApplicationRecord
  validates :channel_id, presence: true, uniqueness: true

  has_many :videos, dependent: :destroy
end
