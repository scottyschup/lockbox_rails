class CreateSupportRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :support_requests do |t|
      t.string :client_ref_id
      t.string :name_or_alias
      t.string :urgency_flag
      t.references :lockbox_partner, foreign_key: true

      t.timestamps
    end
  end
end
