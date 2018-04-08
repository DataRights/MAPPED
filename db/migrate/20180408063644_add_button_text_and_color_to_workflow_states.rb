class AddButtonTextAndColorToWorkflowStates < ActiveRecord::Migration[5.1]
  def change
    add_column :workflow_states, :button_text, :string
    add_column :workflow_states, :button_css_class, :string, default: 'btn'
    add_column :workflow_states, :button_style, :string
  end
end
