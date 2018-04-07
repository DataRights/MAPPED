namespace :mapped do
  desc "This task sets undo transition type on transitions that are named Undo"

  task :set_undo_type => :environment do
    Transition.where(name: 'Undo').update_all(transition_type: :undo)
  end
end
