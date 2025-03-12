class BooksController < ApplicationController
  def index
    @genres = Genre.order(:name)
    @books = Book.order(:title)

    if params[:search].present?
      @books = @books.where("title ILIKE ?", "%#{params[:search]}%")
    end

    if params[:genre_id].present?
      @books = @books.joins(:genres).where(genres: { id: params[:genre_id] })
    end

    @books = @books.page(params[:page]).per(10)
  end
  def show
    @book = Book.find_by(id: params[:id])

    if @book.nil?
      redirect_to books_path, alert: "Book not found."
    end
  end
end
