class Answer < ApplicationRecord
  belongs_to :answerable, polymorphic: true
end
