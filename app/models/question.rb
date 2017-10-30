class Question < ApplicationRecord
	QUESTION_TYPES = [:simple, :multiple, :select_list]

	validate :validate_metadata

	def self.new_question(question_type)
		case question_type
		when :simple
			return QuestionSimple.new
		when :multiple
			return QuestionMultiple.new
		when :select_list
			return QuestionSelectList.new
		else
			raise "Unkonown question_type #{question_type}"
		end
	end

	def validate_metadata
		errors[:metadata] << "Base class error"
	end

end
