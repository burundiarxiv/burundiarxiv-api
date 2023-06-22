require "rails_helper"

RSpec.describe Leaderboard do
  let(:games_with_solution) { Game.with_solution("solution") }
  let(:games_won_with_solution) { Game.won_with_solution("solution") }

  describe "#best_players" do
    it "returns the 10 best players for a given solution" do
      create(:game, score: 20, country: "Burundi", start_time: "2022-03-30T01:25:57+02:00Z")
      create(:game, score: 21, country: "Burundi", start_time: "2022-03-30T01:25:57+02:00Z")
      create(:game, score: 22, country: "Burundi", solution: "other")
      create(:game, score: 21, country: "Burundi")
      create(:game, score: 20, country: "Belgium")
      create(:game, score: 19, country: "Burundi")
      create(:game, score: 18, country: "Rwanda")
      create(:game, score: 17)
      create(:game, score: 16, country: "Burundi")
      create(:game, score: 15, country: "Sweden")
      create(:game, score: 14, country: "Burundi")
      create(:game, score: 13, country: "Burundi")
      create(:game, score: 12, country: "Canada")
      create(:game, score: 11, country: "Burundi")
      create(:game, score: 10, country: "Germany")

      expect(
        described_class.call(
          games_with_solution: games_with_solution,
          games_won_with_solution: games_won_with_solution,
        )[
          :best_players
        ],
      ).to eq(
        [
          { rank: 1, score: 21.0, country: "Burundi" },
          { rank: 2, score: 20.0, country: "Belgium" },
          { rank: 3, score: 19.0, country: "Burundi" },
          { rank: 4, score: 18.0, country: "Rwanda" },
          { rank: 5, score: 17.0, country: "France" },
          { rank: 6, score: 16.0, country: "Burundi" },
          { rank: 7, score: 15.0, country: "Sweden" },
          { rank: 8, score: 14.0, country: "Burundi" },
          { rank: 9, score: 13.0, country: "Burundi" },
          { rank: 10, score: 12.0, country: "Canada" },
        ],
      )
    end
  end

  describe "#players_by_country" do
    it "returns the top 5 countries with most players" do
      create(:game, score: 20, country: "Burundi", start_time: "2022-03-30T01:25:57+02:00Z")
      create(:game, score: 21, country: "Burundi", start_time: "2022-03-30T01:25:57+02:00Z")
      create(:game, score: 22, country: "Burundi", solution: "other")
      create(:game, score: 21, country: "Burundi")
      create(:game, score: 20, country: "Burundi")
      create(:game, score: 19, country: "Burundi")
      create(:game, score: 18, country: "Burundi", won: false)
      create(:game, score: 17, country: "Burundi")
      create(:game, score: 16, country: "Belgium")
      create(:game, score: 15, country: "Belgium")
      create(:game, score: 14, country: "Belgium", won: false)
      create(:game, score: 11, country: "Belgium")
      create(:game, score: 13, country: "Rwanda")
      create(:game, score: 12, country: "Rwanda")
      create(:game, score: 10, country: "Rwanda")
      create(:game, score: 10, country: "France", won: false)
      create(:game, score: 10, country: "France")
      create(:game, score: 10, country: "Sweden")
      create(:game, score: 10, country: "Germany")

      expect(
        described_class.call(
          games_with_solution: games_with_solution,
          games_won_with_solution: games_won_with_solution,
        )[
          :players_by_country
        ],
      ).to eq(
        [
          { rank: 1, country: "Burundi", count: 5 },
          { rank: 2, country: "Belgium", count: 4 },
          { rank: 3, country: "Rwanda", count: 3 },
          { rank: 4, country: "France", count: 2 },
          { rank: 5, country: "Germany", count: 1 },
          { rank: 6, country: "Sweden", count: 1 },
        ],
      )
    end
  end
end
