require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
	test 'should have question_type' do
		question = Question.new
		assert_not question.valid?
		assert_includes question.errors[:question_type],'question_type cannot be empty'
	end
end
