FactoryBot.define do
  factory :video do
    youtuber
    video_id { 'MyString' }
    title { 'MyString' }
    description { 'MyString' }
    thumbnail { 'MyString' }
  end
end
