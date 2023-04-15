# spec/jobs/update_youtuber_statistics_job_spec.rb

require 'rails_helper'

RSpec.describe UpdateYoutuberStatisticsJob, type: :job do
  describe '#perform' do
    # We'll create a youtuber and channel as test data
    let!(:channel) { double('channel', view_count: 100, video_count: 10, subscriber_count: 20) }
    let!(:youtuber) { create(:youtuber) }

    before { allow_any_instance_of(Youtuber).to receive(:channel).and_return(channel) }

    it 'updates youtuber statistics with the current date and channel data' do
      # Enqueue the job and perform the assertions on the results
      expect { described_class.perform_now }.to change { YoutuberStatistic.count }.by(1)

      # Ensure the correct youtuber statistic was created or updated with the expected data
      youtuber_statistic = youtuber.youtuber_statistics.find_by(date: Date.today)
      expect(youtuber_statistic).not_to be_nil
      expect(youtuber_statistic.view_count).to eq(channel.view_count)
      expect(youtuber_statistic.video_count).to eq(channel.video_count)
      expect(youtuber_statistic.subscriber_count).to eq(channel.subscriber_count)
    end
  end
end
