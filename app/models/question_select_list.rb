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
#  In Visuals you can set select_type  it can be `select`  or `radio`  default is `select`
#  if you choose `radio` as select_type in your visual you can also choose direction of rendering
#  by default it is `vertical` but you can choose to have `horizontal` radio buttons 

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
