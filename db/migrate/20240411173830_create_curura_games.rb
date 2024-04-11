class CreateCururaGames < ActiveRecord::Migration[7.1]
  def change
    create_table :curura_games do |t|
      t.float :score, default: 0.0
      t.string :country
      t.datetime :start_time

      t.timestamps
    end
  end
end
