# frozen_string_literal: true

class AddTimezoneToGame < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :timezone, :string
  end
end
