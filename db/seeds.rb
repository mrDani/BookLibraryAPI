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

def fetch_books(query)
  url = "https://openlibrary.org/search.json?q=#{query}&limit=10"
  response = HTTParty.get(url)
  return [] unless response.code == 200

  response.parsed_response["docs"]
end

queries = ["science fiction", "history", "fantasy", "philosophy"]
books_data = queries.flat_map { |query| fetch_books(query) }

books_data.each do |book_data|
  next unless book_data["title"] && book_data["author_name"]

  author = Author.find_or_create_by!(name: book_data["author_name"].first) do |a|
    a.birth_date = book_data["author_birth_date"]&.first
  end

  Book.create!(
    title: book_data["title"],
    published_year: book_data["first_publish_year"],
    cover_url: book_data["cover_i"] ? "https://covers.openlibrary.org/b/id/#{book_data['cover_i']}-L.jpg" : nil,
    author: author
  )
end

puts "✅ Book and Author data imported!"
