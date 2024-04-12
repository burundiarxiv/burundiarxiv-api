class ChangeScoreFloatToIntForCururaGames < ActiveRecord::Migration[7.1]
  def change
    change_column :curura_games, :score, :integer
  end
end
