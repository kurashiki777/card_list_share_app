class CreateCards < ActiveRecord::Migration[7.0]
  def change
    create_table :cards do |t|
      t.string :name, null: false
      t.text :remarks
      t.integer :stock_quantity
      t.integer :target_quantity, null: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
