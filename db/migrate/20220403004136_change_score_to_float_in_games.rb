# frozen_string_literal: true

class ChangeScoreToFloatInGames < ActiveRecord::Migration[6.0]
  def change
    change_column :games, :score, :float
  end
end
