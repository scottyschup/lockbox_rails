class AddUserIdToNotes < ActiveRecord::Migration[6.0]
  def change
    add_column :notes, :user_id, :bigint
    add_index :notes, :user_id
  end
end
