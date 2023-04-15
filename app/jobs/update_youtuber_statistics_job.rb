class UpdateYoutuberStatisticsJob < ApplicationJob
  def perform
    Youtuber.find_each do |youtuber|
      youtuber.update_statistics

      channel = youtuber.channel

      stats = {
        view_count: channel.view_count,
        video_count: channel.video_count,
        subscriber_count: channel.subscriber_count,
      }

      youtuber_statistic = youtuber.youtuber_statistics.find_or_initialize_by(date: Date.current)
      youtuber_statistic.assign_attributes(stats)
      youtuber_statistic.save!
    end
  end
end
