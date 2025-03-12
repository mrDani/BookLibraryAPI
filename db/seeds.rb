# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'httparty'
require 'faker'

# Fetch books from Open Library API
def fetch_books(query)
  url = "https://openlibrary.org/search.json?q=#{query}&limit=10"
  response = HTTParty.get(url)
  return [] unless response.code == 200

  response.parsed_response["docs"]
end


queries = ["science fiction", "history", "fantasy", "philosophy"]
books_data = queries.flat_map { |query| fetch_books(query) }

# Create genres
genres = ["Science Fiction", "History", "Fantasy", "Philosophy", "Mystery", "Horror", "Romance"]
genres.each { |name| Genre.find_or_create_by!(name: name) }

# Seed books and authors
books_data.each do |book_data|
  next unless book_data["title"] && book_data["author_name"]

  author = Author.find_or_create_by!(name: book_data["author_name"].first) do |a|
    a.birth_date = book_data["author_birth_date"]&.first
  end

  book = Book.find_or_create_by!(title: book_data["title"], author: author) do |b|
    b.published_year = book_data["first_publish_year"]
    if book_data["cover_i"]
      b.cover_url = "https://covers.openlibrary.org/b/id/#{book_data['cover_i']}-L.jpg"
    else
      b.cover_url = nil
    end
  end
  

  # Assign genres only if the book doesn't already have genres
  if book.genres.empty?
    book.genres << Genre.where(name: genres.sample(rand(1..3)))
  end
end

puts "Books, Authors, and Genres imported successfully!"




# Faker Books and Authors
10.times do
  author = Author.create!(
    name: Faker::Book.author,
    birth_date: Faker::Date.birthday(min_age: 30, max_age: 80).to_s
  )

  book = Book.create!(
    title: Faker::Book.title,
    published_year: rand(1900..2025),
    cover_url: nil,
    author: author
  )

  # Assign random genres
  book.genres << Genre.order("RANDOM()").limit(rand(1..3))
end

