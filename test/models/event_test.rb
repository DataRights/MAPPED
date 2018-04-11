# == Schema Information
#
# Table name: events
#
#  id                :integer          not null, primary key
#  workflow_state_id :integer
#  title             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  display_order     :integer
#  ui_form           :integer
#

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
