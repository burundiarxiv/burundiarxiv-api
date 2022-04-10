# frozen_string_literal: true

class CreateMeanings < ActiveRecord::Migration[6.0]
  def change
    create_table :meanings do |t|
      t.string :keyword, null: false
      t.string :meaning, null: false
      t.string :proverb, null: false

      t.timestamps
    end
  end
end
