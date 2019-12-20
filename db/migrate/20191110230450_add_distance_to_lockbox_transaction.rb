class AddDistanceToLockboxTransaction < ActiveRecord::Migration[6.0]
  def change
    add_column :lockbox_transactions, :distance, :integer
  end
end
