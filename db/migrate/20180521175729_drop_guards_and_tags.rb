class DropGuardsAndTags < ActiveRecord::Migration[5.1]
  def change
      drop_table :guards, force: :cascade
      drop_table :tags, force: :cascade
  end
end
