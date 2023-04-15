FactoryBot.define do
  factory :youtuber do
    subscriber_count { 1 }
    sequence :channel_id do |n|
      "channel_#{n}"
    end
  end
end
