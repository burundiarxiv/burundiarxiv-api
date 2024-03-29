# frozen_string_literal: true

require "rails_helper"

RSpec.describe Game, type: :model do
  describe "validations" do
    it { should validate_presence_of(:country) }
    it { should validate_presence_of(:score) }
    it { should validate_presence_of(:solution) }

    it { should allow_value(true).for(:won) }
    it { should allow_value(false).for(:won) }
    it { should_not allow_value(nil).for(:won) }
  end

  describe "#start_time" do
    it "returns the start_time with in the correct timezone : Europe/Paris" do
      game = create(:game, start_time: "2022-03-30T01:25:57+02:00Z", timezone: "Europe/Paris")
      expect(game.start_time.to_s).to eq "2022-03-30 01:25:57 +0200"
    end

    it "returns the start_time with in the correct timezone : Europe/Dublin" do
      game = create(:game, start_time: "2022-03-30T01:25:57+02:00Z", timezone: "Europe/Dublin")
      expect(game.start_time.to_s).to eq "2022-03-30 00:25:57 +0100"
    end

    it "handles start_time and end_time nil values" do
      game = create(:game, start_time: nil, end_time: nil, timezone: "Europe/Paris")
      expect(game.start_time).to be_nil
      expect(game.end_time).to be_nil
    end
  end

  describe "#compute_score" do
    it "computes the score when game score is a default value of 0" do
      game =
        create(
          :game,
          guesses: %w[AMATA UMUTI INSWA],
          start_time: "2022-03-30T01:25:57+02:00Z",
          time_taken: 81,
        )

      expect(game.score).to eq (81 * 3.0)
    end

    it "when game is not won" do
      game =
        create(
          :game,
          guesses: %w[AMATA UMUTI INSWA],
          start_time: "2022-03-30T01:25:57+02:00Z",
          time_taken: 81,
          won: false,
        )

      expect(game.score).to eq 0
    end

    it "computes score for time taken smaller than 24 hours" do
      game =
        create(
          :game,
          guesses: %w[AMATA UMUTI INSWA],
          start_time: "1970-03-30T01:25:57+02:00Z",
          time_taken: 1_648_936_974,
        )
      expect(game.score).to eq 0
    end
  end
end
