class AddNameToUsers < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :name, :string

    User.reset_column_information
    User.find_each do |user|
      user.update_columns(name: "#{user.first_name} #{user.last_name}".strip)
    end
  end

  def down
    remove_column :users, :name
  end
end
