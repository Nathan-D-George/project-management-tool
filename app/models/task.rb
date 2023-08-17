class Task < ApplicationRecord
  belongs_to :milestone

  validates :name,        presence: true, length: {minimum:  4, maximum:  40}
end
