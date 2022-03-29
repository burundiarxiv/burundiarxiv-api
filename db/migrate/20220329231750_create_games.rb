# frozen_string_literal: true

class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.string :solution
      t.text :guesses, array: true, default: []
      t.boolean :won
      t.datetime :start_time
      t.datetime :end_time
      t.string :country
      t.integer :time_taken

      t.timestamps
    end
  end
end
