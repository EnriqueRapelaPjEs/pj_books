class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :genre, required: true
      t.string :author, required: true
      t.string :image, required: true
      t.string :title, required: true
      t.string :publisher, required: true
      t.integer :year, required: true

      t.timestamps
    end
  end
end
