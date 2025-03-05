class Book < ApplicationRecord
  belongs_to :author

  validates :title, presence: true
  validates :published_year, numericality: { only_integer: true, allow_nil: true }
end
