class RenameSubscriberCount < ActiveRecord::Migration[7.0]
  def change
    rename_column :youtubers, :subscribers, :subscriber_count
  end
end
