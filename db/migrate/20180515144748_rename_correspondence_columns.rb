class RenameCorrespondenceColumns < ActiveRecord::Migration[5.1]
  def change
    rename_column :correspondences, :letter_type, :communication_type
  end
end
