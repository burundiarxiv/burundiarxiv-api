FactoryBot.define do
  factory :youtuber do
    subscriber_count { 10 }
    sequence :channel_id do |n|
      "channel_#{n}"
    end
    view_count { 20 }
    video_count { 30 }
    sequence :title do |n|
      "title_#{n}"
    end
    thumbnail { "MyString" }
    published_at { "2018-10-01 00:00:00" }
  end
end
