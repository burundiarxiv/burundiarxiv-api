require 'rails_helper'

RSpec.describe Youtuber, type: :model do
  it 'has a required columns' do
    expect(Youtuber.column_names).to eq %w[id subscribers channel_id created_at updated_at]
  end
end
