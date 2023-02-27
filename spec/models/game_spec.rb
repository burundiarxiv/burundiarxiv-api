# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  describe '#start_time' do
    it 'returns the start_time with in the correct timezone : Europe/Paris' do
      game = create(:game, start_time: '2022-03-30T01:25:57+02:00Z', timezone: 'Europe/Paris')
      expect(game.start_time.to_s).to eq '2022-03-30 01:25:57 +0200'
    end

    it 'returns the start_time with in the correct timezone : Europe/Dublin' do
      game = create(:game, start_time: '2022-03-30T01:25:57+02:00Z', timezone: 'Europe/Dublin')
      expect(game.start_time.to_s).to eq '2022-03-30 00:25:57 +0100'
    end

    it 'handles start_time and end_time nil values' do
      game = create(:game, start_time: nil, end_time: nil, timezone: 'Europe/Paris')
      expect(game.start_time).to be_nil
      expect(game.end_time).to be_nil
    end
  end

  describe '#compute_score' do
    it 'computes the score when game score is a default value of 0' do
      game =
        create(
          :game,
          guesses: %w[AMATA UMUTI INSWA],
          start_time: '2022-03-30T01:25:57+02:00Z',
          time_taken: 81,
        )

      expect(game.score).to eq (81 * 3.0)
    end

    it 'when game is not won' do
      game =
        create(
          :game,
          guesses: %w[AMATA UMUTI INSWA],
          start_time: '2022-03-30T01:25:57+02:00Z',
          time_taken: 81,
          won: false,
        )

      expect(game.score).to eq 0
    end

    it 'computes score for time taken smaller than 24 hours' do
      game =
        create(
          :game,
          guesses: %w[AMATA UMUTI INSWA],
          start_time: '1970-03-30T01:25:57+02:00Z',
          time_taken: 1_648_936_974,
        )
      expect(game.score).to eq 0
    end
  end

  describe '#median_international_score' do
    it 'computes the median international score' do
      create(:game, score: 1007, country: 'France')
      create(:game, score: 1011, country: 'Canada')
      create(:game, score: 1019, country: 'Burundi')
      create(:game, score: 1020, country: 'Burundi', won: false)
      create(:game, score: 1020, country: 'Burundi', solution: 'other')

      expect(Game.median_international_score(solution: 'solution')).to eq '1 011'
    end

    it 'handles non existing country' do
      expect(Game.median_international_score(solution: 'solution')).to eq '-'
    end

    it 'handles score with 1 won game' do
      create(:game, score: 12, country: 'Burundi')

      expect(Game.median_international_score(solution: 'solution')).to eq '12'
    end

    it 'handles score with 1 lost game' do
      create(:game, score: 12, won: false, country: 'Burundi')

      expect(Game.median_international_score(solution: 'solution')).to eq '-'
    end

    it 'does not take into account old games' do
      create(:game, score: 20, country: 'Burundi', start_time: '2022-03-30T01:25:57+02:00Z')
      create(:game, score: 21, country: 'France', start_time: '2022-03-30T01:25:57+02:00Z')
      create(:game, score: 17, country: 'Burundi')
      create(:game, score: 20, country: 'Burundi')
      create(:game, score: 21, country: 'France')

      expect(Game.median_international_score(solution: 'solution')).to eq('20')
    end
  end

  describe '#median_national_score' do
    it 'computes the median national score' do
      create(:game, score: 7, country: 'France')
      create(:game, score: 11, country: 'Canada')
      create(:game, score: 12, country: 'Burundi')
      create(:game, score: 19, country: 'Burundi')
      create(:game, score: 20, country: 'Burundi', won: false)
      create(:game, score: 20, country: 'Burundi', solution: 'other')

      expect(Game.median_national_score(solution: 'solution', country: 'Burundi')).to eq '16'
    end

    it 'handles non existing country' do
      expect(Game.median_national_score(solution: 'solution', country: 'France')).to eq '-'
    end

    it 'handles score with 1 won game' do
      create(:game, score: 12, country: 'Burundi')

      expect(Game.median_national_score(solution: 'solution', country: 'Burundi')).to eq '12'
    end

    it 'handles score with 1 lost game' do
      create(:game, score: 12, country: 'Burundi', won: false)

      expect(Game.median_national_score(solution: 'solution', country: 'Burundi')).to eq '-'
    end

    it 'does not take into account old games' do
      create(:game, score: 20, country: 'Burundi', start_time: '2022-03-30T01:25:57+02:00Z')
      create(:game, score: 21, country: 'France', start_time: '2022-03-30T01:25:57+02:00Z')
      create(:game, score: 17, country: 'Burundi')
      create(:game, score: 20, country: 'Burundi')
      create(:game, score: 21, country: 'France')

      expect(Game.median_national_score(solution: 'solution', country: 'Burundi')).to eq('19')
    end
  end

  describe '#national_rank' do
    it 'computes the national rank' do
      create(:game, score: 7, country: 'France')
      create(:game, score: 11, country: 'Canada')
      create(:game, score: -18, country: 'Burundi')
      create(:game, score: 12, country: 'Burundi')
      create(:game, score: 15, country: 'Burundi')
      create(:game, score: 17, country: 'Burundi')
      create(:game, score: 19, country: 'Burundi', won: false)
      create(:game, score: 20, country: 'Burundi', solution: 'other')

      expect(Game.national_rank(solution: 'solution', country: 'Burundi', score: 12)).to eq('3/5')
    end

    it 'does not take into account old games' do
      create(:game, score: 20, country: 'Burundi', start_time: '2022-03-30T01:25:57+02:00Z')
      create(:game, score: 21, country: 'France', start_time: '2022-03-30T01:25:57+02:00Z')
      create(:game, score: 17, country: 'Burundi')
      create(:game, score: 20, country: 'Burundi')
      create(:game, score: 21, country: 'France')

      expect(Game.national_rank(solution: 'solution', score: 17, country: 'Burundi')).to eq('2/2')
    end

    it 'displays 1/1 for one player' do
      create(:game, score: 17)
      create(:game, score: 17, country: 'Burundi')

      expect(Game.national_rank(solution: 'solution', score: 17, country: 'Burundi')).to eq('1/1')
    end
  end

  describe '#international_national_rank' do
    it 'computes the international rank' do
      create(:game, score: -15, country: 'Burundi')
      create(:game, score: 7, country: 'France')
      create(:game, score: 11, country: 'Canada')
      create(:game, score: 12, country: 'Burundi')
      create(:game, score: 17, country: 'Burundi')
      create(:game, score: 18, country: 'Burundi')
      create(:game, score: 19, country: 'Burundi', won: false)
      create(:game, score: 20, country: 'Burundi', solution: 'other')

      expect(Game.international_rank(solution: 'solution', score: 17)).to eq('2/7')
    end

    it 'does not take into account old games' do
      create(:game, score: 20, country: 'Canada', start_time: '2022-03-30T01:25:57+02:00Z')
      create(:game, score: 21, country: 'Burundi', start_time: '2022-03-30T01:25:57+02:00Z')
      create(:game, score: 17)
      create(:game, score: 20)

      expect(Game.international_rank(solution: 'solution', score: 17)).to eq('2/2')
    end
  end

  describe '#best_players' do
    it 'returns the 10 best players for a given solution' do
      create(:game, score: 20, country: 'Burundi', start_time: '2022-03-30T01:25:57+02:00Z')
      create(:game, score: 21, country: 'Burundi', start_time: '2022-03-30T01:25:57+02:00Z')
      create(:game, score: 22, country: 'Burundi', solution: 'other')
      create(:game, score: 21, country: 'Burundi')
      create(:game, score: 20, country: 'Belgium')
      create(:game, score: 19, country: 'Burundi')
      create(:game, score: 18, country: 'Rwanda')
      create(:game, score: 17)
      create(:game, score: 16, country: 'Burundi')
      create(:game, score: 15, country: 'Sweden')
      create(:game, score: 14, country: 'Burundi')
      create(:game, score: 13, country: 'Burundi')
      create(:game, score: 12, country: 'Canada')
      create(:game, score: 11, country: 'Burundi')
      create(:game, score: 10, country: 'Germany')

      expect(Game.best_players(solution: 'solution')).to eq(
        [
          { rank: 1, score: 21.0, country: 'Burundi' },
          { rank: 2, score: 20.0, country: 'Belgium' },
          { rank: 3, score: 19.0, country: 'Burundi' },
          { rank: 4, score: 18.0, country: 'Rwanda' },
          { rank: 5, score: 17.0, country: 'France' },
          { rank: 6, score: 16.0, country: 'Burundi' },
          { rank: 7, score: 15.0, country: 'Sweden' },
          { rank: 8, score: 14.0, country: 'Burundi' },
          { rank: 9, score: 13.0, country: 'Burundi' },
          { rank: 10, score: 12.0, country: 'Canada' },
        ],
      )
    end
  end

  describe '#players_by_country' do
    it 'returns the top 5 countries with most players' do
      create(:game, score: 20, country: 'Burundi', start_time: '2022-03-30T01:25:57+02:00Z')
      create(:game, score: 21, country: 'Burundi', start_time: '2022-03-30T01:25:57+02:00Z')
      create(:game, score: 22, country: 'Burundi', solution: 'other')
      create(:game, score: 21, country: 'Burundi')
      create(:game, score: 20, country: 'Burundi')
      create(:game, score: 19, country: 'Burundi')
      create(:game, score: 18, country: 'Burundi', won: false)
      create(:game, score: 17, country: 'Burundi')
      create(:game, score: 16, country: 'Belgium')
      create(:game, score: 15, country: 'Belgium')
      create(:game, score: 14, country: 'Belgium', won: false)
      create(:game, score: 11, country: 'Belgium')
      create(:game, score: 13, country: 'Rwanda')
      create(:game, score: 12, country: 'Rwanda')
      create(:game, score: 10, country: 'Rwanda')
      create(:game, score: 10, country: 'France', won: false)
      create(:game, score: 10, country: 'France')
      create(:game, score: 10, country: 'Sweden')
      create(:game, score: 10, country: 'Germany')

      expect(Game.players_by_country(solution: 'solution')).to eq(
        [
          { rank: 1, country: 'Burundi', count: 5 },
          { rank: 2, country: 'Belgium', count: 4 },
          { rank: 3, country: 'Rwanda', count: 3 },
          { rank: 4, country: 'France', count: 2 },
          { rank: 5, country: 'Germany', count: 1 },
          { rank: 6, country: 'Sweden', count: 1 },
        ],
      )
    end
  end
end
