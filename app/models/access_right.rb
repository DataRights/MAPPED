# == Schema Information
#
# Table name: access_rights
#
#  id         :integer          not null, primary key
#  action     :string
#  role_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AccessRight < ApplicationRecord
	validate :action_content

	belongs_to :role

	ACTIONS = [

		# Admin panel
		:admin_login,

		#User actions
		:view_user,
		:create_user,
		:delete_user,
		:edit_user
	]

	def self.valid_action?(action)
		ACTIONS.include?(action.to_sym)
	end

	def action_content
		errors.add(:action, "Unknown action(#{action})") unless self.class.valid_action?(action)
	end

end
