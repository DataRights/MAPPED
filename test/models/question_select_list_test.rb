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
#

require 'test_helper'

class QuestionSelectListTest < ActiveSupport::TestCase
	test 'should have option_list' do
		question = QuestionSelectList.new
		assert_not question.valid?
		assert_includes  question.errors[:metadata], 'Should have option_list'

		question.metadata = {option_list: 3}
		assert_not question.valid?
		assert_includes question.errors[:metadata],'option_list should be an array'

		question.metadata = {option_list: []}
		assert_not question.valid?
		assert_includes question.errors[:metadata],'option_list should have at list one item'

		question.metadata = {option_list: ['123']}
		assert question.valid?

	end
end
