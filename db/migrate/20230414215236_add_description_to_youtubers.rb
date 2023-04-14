class AddDescriptionToYoutubers < ActiveRecord::Migration[7.0]
  def change
    add_column :youtubers, :description, :string
  end
end
