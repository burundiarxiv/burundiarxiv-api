require 'rails_helper'

RSpec.describe Youtuber, type: :model do
  describe 'database columns' do
    it { should have_db_column(:subscriber_count).of_type(:integer) }
    it { should have_db_column(:channel_id).of_type(:string) }
    it { should have_db_column(:title).of_type(:string) }
    it { should have_db_column(:view_count).of_type(:integer) }
    it { should have_db_column(:video_count).of_type(:integer) }
    it { should have_db_column(:thumbnail).of_type(:string) }
    it { should have_db_column(:published_at).of_type(:datetime) }
    it { should have_db_column(:description).of_type(:string) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:channel_id) }
    it { should validate_uniqueness_of(:channel_id) }
  end

  describe 'Associations' do
    it { should have_many(:videos) }
  end

  describe '#import_videos' do
    context 'when importing a channel\'s videos' do
      let(:channel) { Yt::Channel.new(id: 'example_channel_id') }
      let(:youtuber) { FactoryBot.create(:youtuber) }

      before do
        allow(Yt::Channel).to receive(:new).and_return(channel)
        allow(Youtuber).to receive(:find_by).and_return(youtuber)
      end

      context 'with no existing videos' do
        before do
          allow(Video).to receive(:find_by).and_return(nil)
          allow(channel.videos).to receive(:each)
            .and_yield(
              double(
                'video1',
                id: '111',
                title: 'Title One',
                description: 'Description One',
                thumbnail_url: 'https://example.com/image1.jpg',
                published_at: Time.now,
              ),
            )
            .and_yield(
              double(
                'video2',
                id: '222',
                title: 'Title Two',
                description: 'Description Two',
                thumbnail_url: 'https://example.com/image2.jpg',
                published_at: Time.now,
              ),
            )
        end

        it 'should create all videos' do
          expect { youtuber.import_videos }.to change(Video, :count).by(2)

          expect(youtuber.videos.length).to eq(2)
          expect(Video.pluck(:title)).to contain_exactly('Title One', 'Title Two')
        end
      end

      context 'with existing videos' do
        before do
          allow(Video).to receive(:find_by)
            .with(video_id: '111')
            .and_return(
              FactoryBot.create(
                :video,
                video_id: '111',
                youtuber: youtuber,
                title: 'Previous Title One',
                description: 'Previous Description One',
              ),
            )
          allow(Video).to receive(:find_by)
            .with(video_id: '222')
            .and_return(
              FactoryBot.create(
                :video,
                video_id: '222',
                youtuber: youtuber,
                title: 'Previous Title Two',
                description: 'Previous Description Two',
              ),
            )
          allow(channel.videos).to receive(:each)
            .and_yield(
              double(
                'video1',
                id: '111',
                title: 'Title One',
                description: 'Description One',
                thumbnail_url: 'https://example.com/image1.jpg',
                published_at: Time.now,
              ),
            )
            .and_yield(
              double(
                'video2',
                id: '222',
                title: 'Title Two',
                description: 'Description Two',
                thumbnail_url: 'https://example.com/image2.jpg',
                published_at: Time.now,
              ),
            )
        end

        it 'should update existing videos and create new ones' do
          expect { youtuber.import_videos }.to change(Video, :count).by(0)

          expect(youtuber.videos.length).to eq(2)
          expect(Video.pluck(:title)).to contain_exactly('Title One', 'Title Two')

          expect(Video.find_by(video_id: '111').title).to eq('Title One')
          expect(Video.find_by(video_id: '222').description).to eq('Description Two')
        end
      end
    end
  end
end
