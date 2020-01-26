class AddInvitedByToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :invited_by, foreign_key: { to_table: 'users' }
  end
end
