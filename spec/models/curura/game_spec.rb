require "rails_helper"

RSpec.describe Curura::Game, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:score) }
    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.to validate_presence_of(:start_time) }
  end
end
