class Role < ApplicationRecord
	validates :name, presence: true, uniqueness: true

	has_many :user_roles
	has_many :users, through: :user_roles

	has_many :access_rights

	def can?(action)
		raise "Unknown Action(#{action})" unless AccessRight.valid_action?(action)
		access_rights.where(action: action).size > 0
	end
end
