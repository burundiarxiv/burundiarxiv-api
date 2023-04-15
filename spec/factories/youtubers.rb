FactoryBot.define do
  factory :youtuber do
    subscriber_count { 1 }
    sequence :channel_id do |n|
      "channel_#{n}"
    end
    view_count { 1 }
    video_count { 1 }
    sequence :title do |n|
      "title_#{n}"
    end
  end
end
