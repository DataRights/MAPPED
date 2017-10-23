class AccessRight < ApplicationRecord
	validate :action_content

	belongs_to :role

	ACTIONS = [
		#User actions
		:view_user,
		:create_user,
		:delete_user,
		:edit_user
	]

	def action_content
		errors.add(:action, "Unknown action(#{action})") unless ACTIONS.include?(action.to_sym)
	end

end
