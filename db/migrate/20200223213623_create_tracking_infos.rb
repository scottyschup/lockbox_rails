class CreateTrackingInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :tracking_infos do |t|
      t.string :tracking_number
      t.string :delivery_method
      t.references :lockbox_action, null: false, foreign_key: true
    end
  end
end
