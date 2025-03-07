class Book < ApplicationRecord
  belongs_to :author
  has_many :book_genres, dependent: :destroy
  has_many :genres, through: :book_genres

  validates :title, presence: true
  validates :published_year, numericality: { only_integer: true, allow_nil: true }
end
