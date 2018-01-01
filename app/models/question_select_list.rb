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

class QuestionSelectList < Question
	def validate_metadata
		unless metadata && metadata['option_list']
			errors[:metadata] << "Should have option_list"
			return
		end

		unless metadata['option_list'].is_a?(Array)
			errors[:metadata] << "option_list should be an array"
			return
		end

		errors[:metadata] << 'option_list should have at list one item' unless metadata['option_list'].size > 0
	end
end
