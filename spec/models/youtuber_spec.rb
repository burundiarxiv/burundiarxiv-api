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
end
