class AddSupportRequestIdToLockboxActions < ActiveRecord::Migration[6.0]
  def change
    add_column :lockbox_actions, :support_request_id, :bigint
    add_index :lockbox_actions, :support_request_id
  end
end
