class QuestionValidator < ActiveModel::Validator
	def validate(record)
		record.errors[:question_type] << 'question_type cannot be empty' unless record.question_type
	end
end
