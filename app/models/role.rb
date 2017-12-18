# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Role < ApplicationRecord
	validates :name, presence: true, uniqueness: true

	has_many :user_roles, dependent: :destroy
	has_many :users, through: :user_roles

	has_many :access_rights, dependent: :destroy

	def can?(action)
		raise "Unknown Action(#{action})" unless AccessRight.valid_action?(action)
		access_rights.where(action: action).size > 0
	end
end
