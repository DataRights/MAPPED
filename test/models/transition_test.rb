# == Schema Information
#
# Table name: transitions
#
#  id                    :integer          not null, primary key
#  name                  :string
#  from_state_id         :integer
#  to_state_id           :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  timeout_days          :float
#  ui_form               :integer
#  history_description   :string
#  display_order         :integer          default(10)
#  transition_type       :integer          default("event")
#  is_initial_transition :boolean          default(FALSE)
#

require 'test_helper'

class TransitionTest < ActiveSupport::TestCase
  test "should not allow more than one timeout from one state" do
    t = transitions(:another_letter_needed_by_organization)
    other_transition_timeout = transitions(:took_long_to_get_reply_from_organization)
    t.timeout_days = 4
    assert_not t.save
    assert_equal 1, t.errors.messages[:timeout_days].count, "There should be one error about timeout_days in code: #{t.errors.messages[:timeout_days]}"
    assert_equal I18n.t('workflow.state_has_already_one_timeout_transition', transition: other_transition_timeout.to_json), t.errors.messages[:timeout_days].first
  end
end
