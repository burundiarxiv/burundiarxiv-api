class Youtuber < ApplicationRecord
  validates :channel_id, presence: true, uniqueness: true

  has_many :videos, dependent: :destroy

  def import_videos
    channel.videos.each do |video|
      exising_video = Video.find_by(video_id: video.id)
      if exising_video.nil?
        self.videos.create!(
          video_id: video.id,
          title: video.title,
          description: video.description,
          thumbnail: video.thumbnail_url(:high),
          published_at: video.published_at,
        )
      else
        exising_video.update!(
          title: video.title,
          description: video.description,
          thumbnail: video.thumbnail_url(:high),
        )
      end
    end
  end

  def update_statistics
    update!(
      view_count: channel.view_count,
      video_count: channel.video_count,
      subscriber_count: channel.subscriber_count,
    )
  end

  def channel
    @channel ||= Yt::Channel.new(id: channel_id)
  end
end
