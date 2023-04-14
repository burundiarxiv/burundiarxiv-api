namespace :yt do
  desc 'Update statistics for a specific youtuber'
  task :update_youtuber, [:channel_id] => :environment do |_task, args|
    channel_id = args[:channel_id]
    channel = Yt::Channel.new(id: channel_id)

    youtuber = Youtuber.find_by(channel_id: channel_id)
    youtuber.update!(
      view_count: channel.view_count,
      video_count: channel.video_count,
      subscriber_count: channel.subscriber_count,
    )
  end

  desc 'Create a new youtuber'
  task :create_youtuber, [:channel_id] => :environment do |_task, args|
    channel_id = args[:channel_id]
    channel = Yt::Channel.new(id: channel_id)

    Youtuber.create!(
      title: channel.title,
      channel_id: channel_id,
      view_count: channel.view_count,
      video_count: channel.video_count,
      subscriber_count: channel.subscriber_count,
      published_at: channel.published_at,
      thumbnail: channel.thumbnail_url(:high),
      description: channel.description,
    )
  end

  desc 'Create videos for a specific youtuber'
  task :create_videos, [:channel_id] => :environment do |_task, args|
    channel_id = args[:channel_id]
    channel = Yt::Channel.new(id: channel_id)
    youtuber = Youtuber.find_by(channel_id: channel_id)

    channel.videos.each do |video|
      exising_video = Video.find_by(video_id: video.id)

      if exising_video.nil?
        Video.create!(
          youtuber: youtuber,
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
end
