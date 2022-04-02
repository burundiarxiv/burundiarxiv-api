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

    it 'computes the score when game score is a default value of 0' do
      game =
        create(
          :game,
          guesses: %w[AMATA UMUTI INSWA],
          start_time: '2022-03-30T01:25:57+02:00Z',
          time_taken: 80,
        )
      expect(game.score).to eq 240
    end

    it 'handles start_time and end_time nil values' do
      game =
        create(:game, start_time: nil, end_time: nil, timezone: 'Europe/Paris')
      expect(game.start_time).to be_nil
      expect(game.end_time).to be_nil
    end
  end
end
