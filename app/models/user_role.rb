# == Schema Information
#
# Table name: user_roles
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  role_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class UserRole < ApplicationRecord
	belongs_to :user
	belongs_to :role

	validates :user, uniqueness: { scope: :role }

	attr_accessor :title

  def title
    role.name
  end
end
