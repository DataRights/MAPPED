# == Schema Information
#
# Table name: settings
#
#  id          :integer          not null, primary key
#  key         :string
#  value       :string
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Setting < ApplicationRecord
end
