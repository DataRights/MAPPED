class AddAccessRequestToCorrespondences < ActiveRecord::Migration[5.1]
  def change
    add_reference :correspondences, :access_request, foreign_key: true
  end
end
