class VideoStatistic < ApplicationRecord
  belongs_to :video

  validates :date, presence: true
  validates :view_count,
            :like_count,
            :dislike_count,
            :favorite_count,
            :comment_count,
            numericality: {
              only_integer: true,
            },
            allow_nil: true
end
