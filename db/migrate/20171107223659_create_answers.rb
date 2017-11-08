class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
      t.jsonb    :result
      t.references :answerable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
