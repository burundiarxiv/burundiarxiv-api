class CreateDatasets < ActiveRecord::Migration[6.0]
  def change
    create_table :datasets do |t|
      t.references :category, null: false, foreign_key: true
      t.string :name
      t.integer :slug
      t.string :path

      t.timestamps
    end
  end
end
