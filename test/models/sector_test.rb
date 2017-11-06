# == Schema Information
#
# Table name: sectors
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class SectorTest < ActiveSupport::TestCase
   test "the context_value" do
     assert_equal ({'name' => 'health'}), Sector.new(name: 'health').context_value
   end
end
