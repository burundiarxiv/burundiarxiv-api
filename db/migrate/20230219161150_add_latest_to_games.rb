class AddLatestToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :latest, :boolean, default: true
  end
end
