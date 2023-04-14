require 'rails_helper'

RSpec.describe VideoStatistic, type: :model do
  describe 'database columns' do
    it { should have_db_column(:view_count).of_type(:integer) }
    it { should have_db_column(:like_count).of_type(:integer) }
    it { should have_db_column(:dislike_count).of_type(:integer) }
    it { should have_db_column(:favorite_count).of_type(:integer) }
    it { should have_db_column(:comment_count).of_type(:integer) }
  end

  describe 'Validations' do
    it { should validate_numericality_of(:view_count).only_integer }
    it { should validate_numericality_of(:like_count).only_integer }
    it { should validate_numericality_of(:dislike_count).only_integer }
    it { should validate_numericality_of(:favorite_count).only_integer }
    it { should validate_numericality_of(:comment_count).only_integer }
  end

  describe 'Associations' do
    it { should belong_to(:video) }
  end
end
