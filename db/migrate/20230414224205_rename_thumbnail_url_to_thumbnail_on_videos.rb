class RenameThumbnailUrlToThumbnailOnVideos < ActiveRecord::Migration[7.0]
  def change
    rename_column :videos, :thumbnail_url, :thumbnail
  end
end
