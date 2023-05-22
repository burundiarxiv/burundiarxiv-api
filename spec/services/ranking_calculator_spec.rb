require "rails_helper"

RSpec.describe RankingCalculator do
  describe ".call" do
    it "returns the international rank and the national rank" do
      create(:game, score: 18, country: "Burundi")
      create(:game, score: 17, country: "Burundi")
      create(:game, score: 15, country: "France")
      create(:game, score: 12, country: "Burundi")
      create(:game, score: 11, country: "Canada")
      create(:game, score: 7, country: "France")
      create(:game, score: 19, country: "Burundi", won: false)
      create(:game, score: 20, country: "Burundi", solution: "other")

      games_with_solution = Game.with_solution("solution")
      games_won_with_solution = Game.won_with_solution("solution")

      expect(
        described_class.call(
          games_with_solution: games_with_solution,
          games_won_with_solution: games_won_with_solution,
          country: "Burundi",
          score: 12,
        ),
      ).to eq ({ international_rank: "4/7", national_rank: "3/4" })
    end

    it "returns a dash when there is no game" do
      games_with_solution = Game.with_solution("solution")
      games_won_with_solution = Game.won_with_solution("solution")

      expect(
        described_class.call(
          games_with_solution: games_with_solution,
          games_won_with_solution: games_won_with_solution,
          country: "Burundi",
          score: 12,
        ),
      ).to eq ({ international_rank: "-", national_rank: "-" })
    end

    context "national rank" do
      it "computes the national rank" do
        create(:game, score: 7, country: "France")
        create(:game, score: 11, country: "Canada")
        create(:game, score: -18, country: "Burundi")
        create(:game, score: 12, country: "Burundi")
        create(:game, score: 15, country: "Burundi")
        create(:game, score: 17, country: "Burundi")
        create(:game, score: 19, country: "Burundi", won: false)
        create(:game, score: 20, country: "Burundi", solution: "other")

        games_with_solution = Game.with_solution("solution")
        games_won_with_solution = Game.won_with_solution("solution")

        expect(
          described_class.call(
            games_with_solution: games_with_solution,
            games_won_with_solution: games_won_with_solution,
            country: "Burundi",
            score: 12,
          )[
            :national_rank
          ],
        ).to eq "3/5"
      end

      it "does not take into account old games" do
        create(:game, score: 20, country: "Burundi", start_time: "2022-03-30T01:25:57+02:00Z")
        create(:game, score: 21, country: "France", start_time: "2022-03-30T01:25:57+02:00Z")
        create(:game, score: 17, country: "Burundi")
        create(:game, score: 20, country: "Burundi")
        create(:game, score: 21, country: "France")

        games_with_solution = Game.with_solution("solution")
        games_won_with_solution = Game.won_with_solution("solution")

        expect(
          described_class.call(
            games_with_solution: games_with_solution,
            games_won_with_solution: games_won_with_solution,
            country: "Burundi",
            score: 17,
          )[
            :national_rank
          ],
        ).to eq "2/2"
      end

      it "displays 1/1 for one player" do
        create(:game, score: 17)
        create(:game, score: 17, country: "Burundi")

        games_with_solution = Game.with_solution("solution")
        games_won_with_solution = Game.won_with_solution("solution")

        expect(
          described_class.call(
            games_with_solution: games_with_solution,
            games_won_with_solution: games_won_with_solution,
            country: "Burundi",
            score: 17,
          )[
            :national_rank
          ],
        ).to eq "1/1"
      end
    end

    context "internnational rank" do
      it "computes the international rank" do
        create(:game, score: -15, country: "Burundi")
        create(:game, score: 7, country: "France")
        create(:game, score: 11, country: "Canada")
        create(:game, score: 12, country: "Burundi")
        create(:game, score: 17, country: "Burundi")
        create(:game, score: 18, country: "Burundi")
        create(:game, score: 19, country: "Burundi", won: false)
        create(:game, score: 20, country: "Burundi", solution: "other")

        games_with_solution = Game.with_solution("solution")
        games_won_with_solution = Game.won_with_solution("solution")

        expect(
          described_class.call(
            games_with_solution: games_with_solution,
            games_won_with_solution: games_won_with_solution,
            country: "Burundi",
            score: 17,
          )[
            :international_rank
          ],
        ).to eq "2/7"
      end

      it "does not take into account old games" do
        create(:game, score: 20, country: "Canada", start_time: "2022-03-30T01:25:57+02:00Z")
        create(:game, score: 21, country: "Burundi", start_time: "2022-03-30T01:25:57+02:00Z")
        create(:game, score: 17)
        create(:game, score: 20)

        games_with_solution = Game.with_solution("solution")
        games_won_with_solution = Game.won_with_solution("solution")

        expect(
          described_class.call(
            games_with_solution: games_with_solution,
            games_won_with_solution: games_won_with_solution,
            country: "Burundi",
            score: 17,
          )[
            :international_rank
          ],
        ).to eq "2/2"
      end
    end
  end
end
