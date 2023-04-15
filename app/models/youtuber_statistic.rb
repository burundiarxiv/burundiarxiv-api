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

  def estimated_earnings
    # 1.compute videos views difference between the date of this statistic and the date of the previous statistic
    # 2. multiply the difference by the average earnings per 1000 views
    # 3. return the result

    # 1.
    previous_statistic = youtuber.statistics.where('date < ?', date).order(date: :desc).first

    return if previous_statistic.nil?

    # views_difference = view_count - previous_statistic.view_count
    views_difference = 4967
    min_earnings = ((views_difference * 0.25) / 1_000).round
    max_earnings = ((views_difference * 4.00) / 1_000).round

    "$#{min_earnings} - $#{max_earnings}"
  end
end
