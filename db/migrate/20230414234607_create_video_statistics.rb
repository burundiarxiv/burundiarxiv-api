class CreateVideoStatistics < ActiveRecord::Migration[7.0]
  def change
    create_table :video_statistics do |t|
      t.references :video, null: false, foreign_key: true
      t.integer :view_count
      t.integer :like_count
      t.integer :dislike_count
      t.integer :favorite_count
      t.integer :comment_count

      t.timestamps
    end
  end
end
