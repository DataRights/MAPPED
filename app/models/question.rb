class Question < ApplicationRecord
	QUESTION_TYPES = [:simple, :multiple, :select_list]

	enum question_type: QUESTION_TYPES

	validates_with QuestionValidator
end
