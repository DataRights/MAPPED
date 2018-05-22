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

class Question < ApplicationRecord
	has_and_belongs_to_many :campaigns
	#HA has_many :tags, :as => :tagable, dependent: :destroy

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
