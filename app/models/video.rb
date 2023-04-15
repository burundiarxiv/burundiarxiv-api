class Video < ApplicationRecord
  validates :video_id, presence: true, uniqueness: true

  belongs_to :youtuber
  has_many :video_statistics, dependent: :destroy
end
