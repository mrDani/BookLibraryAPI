class CreateBooks < ActiveRecord::Migration[7.2]
  def change
    create_table :books do |t|
      t.string :title
      t.integer :published_year
      t.string :cover_url
      t.references :author, null: false, foreign_key: true

      t.timestamps
    end
  end
end
