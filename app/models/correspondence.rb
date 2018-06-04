# == Schema Information
#
# Table name: correspondences
#
#  id                     :integer          not null, primary key
#  final_text             :string
#  remarks                :string
#  access_request_step_id :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  correspondence_type    :string
#  medium                 :string
#  direction              :string
#  correspondence_date    :datetime
#

class Correspondence < ApplicationRecord
  include StringEnums
  belongs_to :access_request_step
  has_many :attachments, :as => :attachable, dependent: :destroy
  belongs_to :access_request

  string_enum medium: [:post, :email, :call, :weblink, :meeting, :other]
  string_enum direction: [:incoming, :outgoing]
  string_enum correspondence_type: [:reminder, :'second reminder', :clarification, :question, :data, :access_request]
  validates_presence_of :correspondence_type
end
