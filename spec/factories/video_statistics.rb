FactoryBot.define do
  factory :video_statistic do
    video
    view_count { 1 }
    like_count { 1 }
    dislike_count { 1 }
    favorite_count { 1 }
    comment_count { 1 }
    date { '2021-04-14' }
  end
end
