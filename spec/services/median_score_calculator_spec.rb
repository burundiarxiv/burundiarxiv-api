require "rails_helper"

RSpec.describe MedianScoreCalculator do
  let(:games_won_with_solution) { Game.won_with_solution("solution") }

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

      expect(described_class.call(games: games_won_with_solution, country: "Burundi")).to eq (
           { international_score: "14", national_score: "17" }
         )
    end

    it "returns a dash when there is no game" do
      expect(described_class.call(games: games_won_with_solution, country: "Burundi")).to eq (
           { international_score: "-", national_score: "-" }
         )
    end

    context "median_international_score" do
      it "computes the median international score" do
        create(:game, score: 1007, country: "France")
        create(:game, score: 1011, country: "Canada")
        create(:game, score: 1019, country: "Burundi")
        create(:game, score: 1020, country: "Burundi", won: false)
        create(:game, score: 1020, country: "Burundi", solution: "other")

        expect(
          described_class.call(games: games_won_with_solution, country: "Burundi")[
            :international_score
          ],
        ).to eq "1 011"
      end

      it "handles non existing country" do
        expect(
          described_class.call(games: games_won_with_solution, country: "France")[
            :international_score
          ],
        ).to eq "-"
      end

      it "handles score with 1 won game" do
        create(:game, score: 12, country: "Burundi")

        expect(
          described_class.call(games: games_won_with_solution, country: "Burundi")[
            :international_score
          ],
        ).to eq "12"
      end

      it "handles score with 1 lost game" do
        create(:game, score: 12, won: false, country: "Burundi")

        expect(
          described_class.call(games: games_won_with_solution, country: "Burundi")[
            :international_score
          ],
        ).to eq "-"
      end

      it "does not take into account old games" do
        create(:game, score: 20, country: "Burundi", start_time: "2022-03-30T01:25:57+02:00Z")
        create(:game, score: 21, country: "France", start_time: "2022-03-30T01:25:57+02:00Z")
        create(:game, score: 17, country: "Burundi")
        create(:game, score: 20, country: "Burundi")
        create(:game, score: 21, country: "France")

        expect(
          described_class.call(games: games_won_with_solution, country: "Burundi")[
            :international_score
          ],
        ).to eq("20")
      end
    end

    context "median_national_score" do
      it "computes the median national score" do
        create(:game, score: 7, country: "France")
        create(:game, score: 11, country: "Canada")
        create(:game, score: 12, country: "Burundi")
        create(:game, score: 19, country: "Burundi")
        create(:game, score: 20, country: "Burundi", won: false)
        create(:game, score: 20, country: "Burundi", solution: "other")

        expect(
          described_class.call(games: games_won_with_solution, country: "Burundi")[:national_score],
        ).to eq "16"
      end

      it "handles non existing country" do
        expect(
          described_class.call(games: games_won_with_solution, country: "France")[:national_score],
        ).to eq "-"
      end

      it "handles score with 1 won game" do
        create(:game, score: 12, country: "Burundi")

        expect(
          described_class.call(games: games_won_with_solution, country: "Burundi")[:national_score],
        ).to eq "12"
      end

      it "handles score with 1 lost game" do
        create(:game, score: 12, country: "Burundi", won: false)

        expect(
          described_class.call(games: games_won_with_solution, country: "Burundi")[:national_score],
        ).to eq("-")
      end

      it "does not take into account old games" do
        create(:game, score: 20, country: "Burundi", start_time: "2022-03-30T01:25:57+02:00Z")
        create(:game, score: 21, country: "France", start_time: "2022-03-30T01:25:57+02:00Z")
        create(:game, score: 17, country: "Burundi")
        create(:game, score: 20, country: "Burundi")
        create(:game, score: 21, country: "France")

        expect(
          described_class.call(games: games_won_with_solution, country: "Burundi")[:national_score],
        ).to eq("19")
      end
    end
  end
end
