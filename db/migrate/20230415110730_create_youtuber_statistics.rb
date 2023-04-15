class CreateYoutuberStatistics < ActiveRecord::Migration[7.0]
  def change
    create_table :youtuber_statistics do |t|
      t.references :youtuber, null: false, foreign_key: true
      t.integer :view_count
      t.integer :video_count
      t.integer :subscriber_count
      t.date :date

      t.timestamps
    end
  end
end
