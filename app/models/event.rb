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

class Event < ApplicationRecord
  belongs_to :workflow_state
  enum ui_form: [:upload_attachment, :response_received]

  validates_presence_of :title
end
