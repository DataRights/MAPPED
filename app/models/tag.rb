# == Schema Information
#
# Table name: tags
#
#  id           :integer          not null, primary key
#  name         :string
#  tagable_type :string
#  tagable_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Tag < ApplicationRecord
  belongs_to :tagable, :polymorphic => true
end
