# == Schema Information
#
# Table name: answers
#
#  id              :integer          not null, primary key
#  result          :jsonb
#  answerable_type :string
#  answerable_id   :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Answer < ApplicationRecord
  belongs_to :answerable, polymorphic: true
end
