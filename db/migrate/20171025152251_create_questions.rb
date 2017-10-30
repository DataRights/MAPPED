class CreateQuestions < ActiveRecord::Migration[5.1]
	def change
		create_table :questions do |t|
			t.text    :title
			t.integer :question_type
			t.jsonb   :metadata
			t.boolean :mandatory
			t.string  :ui_class
			t.timestamps
		end
	end
end
