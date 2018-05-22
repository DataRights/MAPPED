class RenameLetterToOutgoingCommunication < ActiveRecord::Migration[5.1]
  def change
    rename_table :letters, :outgoing_communications
  end
end
