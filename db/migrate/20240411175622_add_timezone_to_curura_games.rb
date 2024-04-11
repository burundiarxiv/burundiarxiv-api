class AddTimezoneToCururaGames < ActiveRecord::Migration[7.1]
  def change
    add_column :curura_games, :timezone, :string
  end
end
