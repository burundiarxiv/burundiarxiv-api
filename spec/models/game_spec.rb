# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  describe '#start_time' do
    it 'returns the start_time with in the correct timezone : Europe/Paris' do
      game =
        create(
          :game,
          start_time: '2022-03-30T01:25:57+02:00Z',
          timezone: 'Europe/Paris',
        )
      expect(game.start_time.to_s).to eq '2022-03-30 01:25:57 +0200'
    end

    it 'returns the start_time with in the correct timezone : Europe/Dublin' do
      game =
        create(
          :game,
          start_time: '2022-03-30T01:25:57+02:00Z',
          timezone: 'Europe/Dublin',
        )
      expect(game.start_time.to_s).to eq '2022-03-30 00:25:57 +0100'
    end

    it 'handles start_time and end_time nil values' do
      game =
        create(:game, start_time: nil, end_time: nil, timezone: 'Europe/Paris')
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
      create(:game, score: 7, country: 'France')
      create(:game, score: 11, country: 'Canada')
      create(:game, score: 19, country: 'Burundi')
      create(:game, score: 19, country: 'Burundi', won: false)
      create(:game, score: 20, country: 'Burundi', solution: 'other')

      expect(Game.median_international_score(solution: 'solution')).to eq 11.0
    end

    it 'handles non existing country' do
      expect(Game.median_international_score(solution: 'solution')).to eq 0
    end
  end

  describe '#median_national_score' do
    it 'computes the median national score' do
      create(:game, score: 7, country: 'France')
      create(:game, score: 11, country: 'Canada')
      create(:game, score: 12, country: 'Burundi')
      create(:game, score: 19, country: 'Burundi')
      create(:game, score: 19, country: 'Burundi', won: false)
      create(:game, score: 20, country: 'Burundi', solution: 'other')

      expect(
        Game.median_national_score(solution: 'solution', country: 'Burundi'),
      ).to eq 15.5
    end

    it 'handles non existing country' do
      expect(
        Game.median_national_score(solution: 'solution', country: 'France'),
      ).to eq 0
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

      expect(
        Game.national_rank(solution: 'solution', country: 'Burundi', score: 17),
      ).to eq('1/4')
    end
  end

  describe '#internal_national_rank' do
    it 'computes the international rank' do
      create(:game, score: -15, country: 'Burundi')
      create(:game, score: 7, country: 'France')
      create(:game, score: 11, country: 'Canada')
      create(:game, score: 12, country: 'Burundi')
      create(:game, score: 17, country: 'Burundi')
      create(:game, score: 18, country: 'Burundi')
      create(:game, score: 19, country: 'Burundi', won: false)
      create(:game, score: 20, country: 'Burundi', solution: 'other')

      expect(Game.international_rank(solution: 'solution', score: 17)).to eq(
        '2/6',
      )
    end
  end
end
