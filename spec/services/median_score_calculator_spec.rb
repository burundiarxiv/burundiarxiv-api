require "rails_helper"

RSpec.describe MedianScoreCalculator do
  describe ".call" do
    it "returns the international median score and the national median score" do
      create(:game, score: 18, country: "Burundi")
      create(:game, score: 17, country: "Burundi")
      create(:game, score: 15, country: "France")
      create(:game, score: 12, country: "Burundi")
      create(:game, score: 11, country: "Canada")
      create(:game, score: 7, country: "France")
      create(:game, score: 19, country: "Burundi", won: false)
      create(:game, score: 20, country: "Burundi", solution: "other")

      games = Game.won_with_solution("solution")

      expect(described_class.call(games: games, country: "Burundi")).to eq %w[14 17]
    end

    it "returns a dash when there is no game" do
      games = Game.won_with_solution("solution")

      expect(described_class.call(games: games, country: "Burundi")).to eq %w[- -]
    end
  end
end
