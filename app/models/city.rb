class City < ApplicationRecord
  belongs_to :country

  def context_value
    {'name' => name}
  end
end
