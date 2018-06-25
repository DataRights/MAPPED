# == Schema Information
#
# Table name: workflow_type_versions
#
#  id               :integer          not null, primary key
#  version          :float
#  workflow_type_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  active           :boolean          default(FALSE)
#  name             :string           default("-"), not null
#

class WorkflowTypeVersion < ApplicationRecord
  belongs_to :workflow_type
  has_many :workflow_states, dependent: :destroy
  validates :version, :workflow_type, presence: true
  validates :version, uniqueness: { scope: :workflow_type }
  validate :presence_of_initial_state
  validates_presence_of :name
  after_save :make_other_versions_inactive

  attr_accessor :diagram

  def make_other_versions_inactive
    return unless self.active
    other_versions = WorkflowTypeVersion.where(active: true, workflow_type_id: self.workflow_type.id).where.not(id: self.id)
    other_versions.each do |o|
      o.active = false
      o.save!
    end
  end

  def presence_of_initial_state
    if self.active
      initial_state = WorkflowState.where(workflow_type_version: self, is_initial_state: true).first
      unless initial_state
        errors.add(:active, I18n.t('validations.initial_state_is_mandatory'))
      end

      unless initial_state.possible_transitions.where(is_initial_transition: true).first
        errors.add(:active, I18n.t('validations.initial_transition_doesnt_exist'))
      end
    end
  end

  def generate_dot_diagram

    if self.workflow_states.count == 0
      return false
    end

    g = GraphViz.new( :G, :type => :digraph )

    nodes = {}

    # creating nodes
    self.workflow_states.each do |s|
      nodes[s.id] = g.add_nodes(s.name)
    end

    # creating relations between nodes
    self.workflow_states.each do |s|
      s.possible_transitions.each do |t|
        g.add_edges(nodes[t.from_state_id], nodes[t.to_state_id], label: t.name, labelfontsize: 4.0)
      end
    end

    file_path = Rails.root.join('public', "#{self.id}.png")
    g.output( :png => file_path )
    return true
  end

  # This is a helper used in rails_admin please see config/initializers/rails_admin.rb config.model WorkflowTypeVersion
  def diagram
    self.id
  end

  def diagram_path
    "/#{self.id}.png"
  end
end
