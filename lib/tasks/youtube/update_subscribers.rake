namespace :yt do
  desc 'Update statistics for a specific youtuber'
  task :update_youtuber, [:channel_id] => :environment do |_task, args|
    channel_id = args[:channel_id]
    channel = Yt::Channel.new(id: channel_id)
    view_count = channel.view_count
    video_count = channel.video_count
    subscriber_count = channel.subscriber_count

    youtuber = Youtuber.find_by(channel_id: channel_id)
    youtuber.update!(
      view_count: view_count,
      video_count: video_count,
      subscriber_count: subscriber_count,
    )
  end
end
