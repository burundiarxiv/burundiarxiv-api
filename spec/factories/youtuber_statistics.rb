FactoryBot.define do
  factory :youtuber_statistic do
    youtuber
    view_count { 1 }
    video_count { 1 }
    subscriber_count { 1 }
    date { '2023-04-15' }
  end
end
