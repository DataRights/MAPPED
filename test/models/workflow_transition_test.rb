# == Schema Information
#
# Table name: workflow_transitions
#
#  id                      :integer          not null, primary key
#  workflow_id             :integer
#  transition_id           :integer
#  failed_action_id        :integer
#  failed_guard_id         :integer
#  action_failed_message   :string
#  failed_guard_message    :string
#  status                  :string
#  rollback_failed_actions :jsonb
#  performed_actions       :jsonb
#  internal_data           :jsonb
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  remarks                 :string
#  event_id                :integer
#

require 'test_helper'

class WorkflowTransitionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
