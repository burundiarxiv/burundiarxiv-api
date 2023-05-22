# frozen_string_literal: true

require "rails_helper"

RSpec.describe Meaning, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:keyword) }
    it { is_expected.to validate_presence_of(:meaning) }
    it { is_expected.to validate_presence_of(:proverb) }
  end
end
