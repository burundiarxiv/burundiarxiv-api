class Youtuber < ApplicationRecord
  validates :channel_id, presence: true, uniqueness: true
end
