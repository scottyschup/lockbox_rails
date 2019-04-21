class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.text :text
      t.bigint :notable_id
      t.string :notable_type

      t.timestamps
    end

    add_index :notes, [:notable_type, :notable_id]
  end
end
