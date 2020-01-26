class AddNoteType < ActiveRecord::Migration[6.0]
  def change
    add_column :notes, :notable_action, :string, default: "annotate"
  end
end
