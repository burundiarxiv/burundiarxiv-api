require 'rails_helper'

RSpec.describe UpdateVideoStatisticsJob, type: :job do
  describe '#perform' do
    # We'll create youtubers and their videos as test data
    let!(:youtuber1) { create(:youtuber) }
    let!(:youtuber2) { create(:youtuber) }
    let!(:video1_1) { create(:video, youtuber: youtuber1) }
    let!(:video1_2) { create(:video, youtuber: youtuber1) }
    let!(:video2_1) { create(:video, youtuber: youtuber2) }

    before do
      # Stub Yt::Video.new(id: video.video_id) so that no actual calls are made in our tests
      allow_any_instance_of(Yt::Video).to receive(:view_count).and_return(100)
      allow_any_instance_of(Yt::Video).to receive(:like_count).and_return(20)
      allow_any_instance_of(Yt::Video).to receive(:dislike_count).and_return(5)
      allow_any_instance_of(Yt::Video).to receive(:favorite_count).and_return(10)
      allow_any_instance_of(Yt::Video).to receive(:comment_count).and_return(4)
    end

    it 'updates video statistics for all videos' do
      # Call perform on the job
      UpdateVideoStatisticsJob.perform_now

      # Ensure statistics are updated for each video
      expect(video1_1.video_statistics.count).to eq(1)
      expect(video1_2.video_statistics.count).to eq(1)
      expect(video2_1.video_statistics.count).to eq(1)

      # Ensure statistics values are correct
      expect(video1_1.video_statistics.first.view_count).to eq(100)
      expect(video1_1.video_statistics.first.like_count).to eq(20)
      expect(video1_1.video_statistics.first.dislike_count).to eq(5)
      expect(video1_1.video_statistics.first.favorite_count).to eq(10)
      expect(video1_1.video_statistics.first.comment_count).to eq(4)
    end
  end
end
