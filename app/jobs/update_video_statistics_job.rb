class UpdateVideoStatisticsJob < ApplicationJob
  def perform
    Video.find_each do |video|
      yt_video = Yt::Video.new(id: video.video_id)

      stats = {
        view_count: yt_video.view_count,
        like_count: yt_video.like_count,
        dislike_count: yt_video.dislike_count,
        favorite_count: yt_video.favorite_count,
        comment_count: yt_video.comment_count,
      }

      video_statistic = video.video_statistics.find_or_initialize_by(date: Date.current)
      video_statistic.assign_attributes(stats)
      video_statistic.save!
    end
  end
end
