namespace :yt do
  desc 'Create a new youtuber'
  task :create_youtuber, [:channel_id] => :environment do |_task, args|
    channel_id = args[:channel_id]
    channel = Yt::Channel.new(id: channel_id)

    youtuber =
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
    youtuber.import_videos
  end

  desc 'Update statistics for all youtubers'
  task update_youtubers: :environment do
    Youtuber.find_each { |youtuber| youtuber.update_statistics }
  end

  desc 'Import videos for all youtubers'
  task import_videos: :environment do
    Youtuber.find_each { |youtuber| youtuber.import_videos }
  end

  desc 'Update video statistics for all youtubers'
  task update_video_statistics: :environment do
    UpdateVideoStatisticsJob.perform_now
  end
end
