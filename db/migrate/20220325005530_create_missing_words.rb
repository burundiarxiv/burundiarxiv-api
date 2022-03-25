# frozen_string_literal: true

class CreateMissingWords < ActiveRecord::Migration[6.0]
  def change
    create_table :missing_words do |t|
      t.string :value
      t.integer :count, default: 1

      t.timestamps
    end
  end
end
