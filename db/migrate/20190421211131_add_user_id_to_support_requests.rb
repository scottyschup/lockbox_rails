class AddUserIdToSupportRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :support_requests, :user_id, :bigint
    add_index :support_requests, :user_id
  end
end
