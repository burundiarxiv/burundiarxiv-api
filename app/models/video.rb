class Video < ApplicationRecord
  validates :video_id, presence: true, uniqueness: true

  belongs_to :youtuber
end
