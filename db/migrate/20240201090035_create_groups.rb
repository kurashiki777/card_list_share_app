class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.text :introduction
      t.string :invitation_code
      t.integer :owner_id

      t.timestamps
    end
  end
end
