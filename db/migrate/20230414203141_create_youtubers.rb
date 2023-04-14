class CreateYoutubers < ActiveRecord::Migration[7.0]
  def change
    create_table :youtubers do |t|
      t.integer :subscribers
      t.string :channel_id

      t.timestamps
    end
  end
end
