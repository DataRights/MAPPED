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

class QuestionSimple < Question
	ANSWER_TYPE = [:number, :text, :boolean, :date, :time]

	def validate_metadata
		unless metadata && metadata['answer_type']
			errors[:metadata] <<  'Should have answer_type'
			return
		end
		errors[:metadata] <<  "#{metadata['answer_type']} is not a valid answer_type" unless ANSWER_TYPE.include? metadata['answer_type'].to_sym
	end
end
