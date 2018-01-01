class AddSentDateToLetter < ActiveRecord::Migration[5.1]
  def change
    add_column :letters, :sent_date, :datetime
  end
end
