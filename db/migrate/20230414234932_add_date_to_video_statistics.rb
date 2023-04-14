class AddDateToVideoStatistics < ActiveRecord::Migration[7.0]
  def change
    add_column :video_statistics, :date, :date, null: false
  end
end
