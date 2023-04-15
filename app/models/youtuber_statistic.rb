class YoutuberStatistic < ApplicationRecord
  belongs_to :youtuber

  validates :date, presence: true
  validates :view_count,
            :subscriber_count,
            :video_count,
            numericality: {
              only_integer: true,
            },
            presence: true
end
