class RemoveQuestionType < ActiveRecord::Migration[5.1]
  def change
    remove_column :questions, :question_type if column_exists? :questions, :question_type
  end
end
