class ChangeSendingMethodToEnum < ActiveRecord::Migration[5.1]
  def change
      drop_table :sending_methods, force: :cascade
  end
end
