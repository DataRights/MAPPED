# == Schema Information
#
# Table name: outgoing_communications
#
#  id                     :integer          not null, primary key
#  communication_type     :integer
#  suggested_text         :string
#  final_text             :string
#  remarks                :string
#  workflow_transition_id :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  sent_date              :datetime
#

class OutgoingCommunication < ApplicationRecord
  belongs_to :workflow_transition
  has_many :attachments, :as => :attachable, dependent: :destroy

  enum communication_type: [:reminder, :'second reminder', :clarification, :question]
  validates_presence_of :communication_type
end
