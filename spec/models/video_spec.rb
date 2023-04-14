require 'rails_helper'

RSpec.describe Video, type: :model do
  describe 'database columns' do
    it { should have_db_column(:video_id).of_type(:string) }
    it { should have_db_column(:title).of_type(:string) }
    it { should have_db_column(:description).of_type(:string) }
    it { should have_db_column(:thumbnail).of_type(:string) }
    it { should have_db_column(:published_at).of_type(:datetime) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:video_id) }
    it { should validate_uniqueness_of(:video_id) }
  end

  describe 'Associations' do
    it { should belong_to(:youtuber) }
  end
end
