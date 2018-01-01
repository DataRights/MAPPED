# == Schema Information
#
# Table name: questions
#
#  id         :integer          not null, primary key
#  title      :text
#  metadata   :jsonb
#  mandatory  :boolean
#  ui_class   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  type       :string
#  visuals    :jsonb
#

require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
	test 'should raise base_class_error' do
		question = Question.new
		assert_not question.valid?
		assert_includes question.errors[:metadata],'Base class error'
	end

	test 'new_question test' do
		assert_kind_of QuestionSimple, Question.new_question(:simple)
		assert_kind_of QuestionMultiple, Question.new_question(:multiple)
		assert_kind_of QuestionSelectList, Question.new_question(:select_list)
		exception = assert_raise (RuntimeError ) {Question.new_question(:an_invalid_option)}
		assert_equal 'Unkonown question_type an_invalid_option', exception.message
	end
end
