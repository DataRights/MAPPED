require 'test_helper'

class QuestionSimpleTest < ActiveSupport::TestCase
	test 'should have answer_type' do
		question = QuestionSimple.new
		assert_not question.valid?
		assert_includes  question.errors[:metadata], 'Should have answer_type'

		question.metadata = {answer_type: :unknown_type}
		assert_not question.valid?
		assert_includes question.errors[:metadata],'unknown_type is not a valid answer_type'

		question.metadata = {answer_type: :number}
		assert question.valid?

	end
end
