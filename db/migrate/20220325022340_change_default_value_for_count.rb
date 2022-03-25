class ChangeDefaultValueForCount < ActiveRecord::Migration[6.0]
  def change
    change_column_default :missing_words, :count, 0
  end
end
