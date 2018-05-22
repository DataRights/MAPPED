class RenameOutgoingCommunicationColumns < ActiveRecord::Migration[5.1]
  def change
    rename_column :outgoing_communications, :letter_type, :communication_type
  end
end
