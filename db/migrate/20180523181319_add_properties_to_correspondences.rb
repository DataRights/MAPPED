class AddPropertiesToCorrespondences < ActiveRecord::Migration[5.1]
  def change
    remove_column :correspondences, :communication_type, :integer
    add_column :correspondences, :correspondence_type, :string
    add_column :correspondences, :medium, :string
    add_column :correspondences, :direction, :string
    remove_column :correspondences, :sent_date, :integer
    add_column :correspondences, :correspondence_date, :datetime
    remove_column :correspondences, :suggested_text, :string
  end
end
