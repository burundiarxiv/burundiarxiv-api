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
end
