class AddColumnsToYoutubers < ActiveRecord::Migration[7.0]
  def change
    add_column :youtubers, :title, :string
    add_column :youtubers, :view_count, :integer
    add_column :youtubers, :video_count, :integer
    add_column :youtubers, :thumbnail, :string
    add_column :youtubers, :published_at, :datetime
  end
end
