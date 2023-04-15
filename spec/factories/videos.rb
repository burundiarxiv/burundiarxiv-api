FactoryBot.define do
  factory :video do
    youtuber

    sequence (:video_id) do |n|
      "video_#{n}"
    end
    title { 'MyString' }
    description { 'MyString' }
    thumbnail { 'MyString' }
  end
end
