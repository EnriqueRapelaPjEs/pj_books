class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, required: true
      t.string :name, required: true
      t.string :last_name, required: true

      t.timestamps
    end
  end
end
