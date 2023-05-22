require "rails_helper"

RSpec.describe YoutuberStatistic, type: :model do
  describe "database columns" do
    it { should have_db_column :youtuber_id }
    it { should have_db_column(:view_count).of_type(:integer) }
    it { should have_db_column(:subscriber_count).of_type(:integer) }
    it { should have_db_column(:video_count).of_type(:integer) }
    it { should have_db_column(:date).of_type(:date) }
  end

  describe "Validations" do
    it { should validate_presence_of :view_count }
    it { should validate_presence_of :subscriber_count }
    it { should validate_presence_of :video_count }

    it { should validate_numericality_of(:view_count).only_integer }
    it { should validate_numericality_of(:subscriber_count).only_integer }
    it { should validate_numericality_of(:video_count).only_integer }
  end

  describe "Associations" do
    it { should belong_to :youtuber }
  end
end
