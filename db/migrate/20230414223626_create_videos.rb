class CreateVideos < ActiveRecord::Migration[7.0]
  def change
    create_table :videos do |t|
      t.references :youtuber, null: false, foreign_key: true
      t.string :title
      t.string :description
      t.string :thumbnail_url

      t.timestamps
    end
  end
end
