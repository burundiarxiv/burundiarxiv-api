require "rails_helper"

RSpec.describe Video, type: :model do
  describe "database columns" do
    it { should have_db_column(:video_id).of_type(:string) }
    it { should have_db_column(:title).of_type(:string) }
    it { should have_db_column(:description).of_type(:string) }
    it { should have_db_column(:thumbnail).of_type(:string) }
    it { should have_db_column(:published_at).of_type(:datetime) }
  end

  describe "Validations" do
    subject { build(:video) }
    it { should validate_presence_of(:video_id) }
    it { should validate_uniqueness_of(:video_id) }
  end

  describe "Associations" do
    it { should belong_to(:youtuber) }
  end

  describe "#statistics" do
    # We'll use a youtuber and two videos with different statistics dates as test data
    let(:youtuber) { create(:youtuber) }
    let!(:video1) { create(:video, youtuber: youtuber) }
    let!(:video2) { create(:video, youtuber: youtuber) }
    let!(:video1_statistics_old) { create(:video_statistic, video: video1, date: 2.days.ago) }
    let!(:video1_statistics_new) { create(:video_statistic, video: video1, date: 1.day.ago) }
    let!(:video2_statistics_old) { create(:video_statistic, video: video2, date: 4.days.ago) }
    let!(:video2_statistics_new) { create(:video_statistic, video: video2, date: Time.zone.today) }

    it "should return the latest statistics" do
      # Ensure it returns the latest statistics for each video
      expect(video1.statistics).to eq(video1_statistics_new)
      expect(video2.statistics).to eq(video2_statistics_new)
    end
  end
end
