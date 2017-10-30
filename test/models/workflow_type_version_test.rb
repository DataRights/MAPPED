# == Schema Information
#
# Table name: workflow_type_versions
#
#  id               :integer          not null, primary key
#  version          :float
#  workflow_type_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  active           :boolean          default(FALSE)
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
end
