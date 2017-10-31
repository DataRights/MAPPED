# == Schema Information
#
# Table name: workflow_type_versions
#
#  id               :integer          not null, primary key
#  version          :float
#  workflow_type_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class WorkflowTypeVersionTest < ActiveSupport::TestCase
  test "making a workflow type active, should make other active version inactive" do

    # other versions of same workflow should get inactive
    new_wf = workflow_type_versions(:version_one_point_one_mapped_social)
    old_wf = workflow_type_versions(:version_one_point_o_mapped_social)
    assert_not new_wf.active
    assert old_wf.active
    new_wf.active = true
    new_wf.save!
    old_wf.reload
    assert_not old_wf.active

    # other types of workflow should stays active
    one = workflow_type_versions(:one)
    assert one.active
  end

  test 'For activating a workflow having an initial state is mandatory' do
    wf = workflow_type_versions(:two)
    wf.active = true
    assert_not wf.save
    assert_equal 1, wf.errors.count, "There should be one validation error: #{wf.errors}"
    assert_equal 1, wf.errors.messages[:active].count, "There should be one error about active value in code: #{wf.errors.messages[:active]}"
    assert_equal I18n.t('validations.initial_state_is_mandatory'), wf.errors.messages[:active].first
  end
end
