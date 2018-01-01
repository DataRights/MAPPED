# == Schema Information
#
# Table name: letters
#
#  id                     :integer          not null, primary key
#  letter_type            :integer
#  suggested_text         :string
#  final_text             :string
#  remarks                :string
#  workflow_transition_id :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  sent_date              :datetime
#

class Letter < ApplicationRecord
  belongs_to :workflow_transition
  enum letter_type: [:reminder, :clarification, :question]
  validates_presence_of :letter_type
end
