class CreateBookSuggestions < ActiveRecord::Migration[7.0]
  def change
    create_table :book_suggestions do |t|
      t.string :synopsis, null: true
      t.float :price, null: true
      t.string :link, null: false
      t.references :book, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
