class BooksController < ApplicationController
  def index
    @books = if params[:search]
               Book.where("title ILIKE ?", "%#{params[:search]}%")
             else
               Book.order(:title)
             end

    @books = @books.page(params[:page]).per(10) # Ensure pagination is applied
  end

  def show
    @book = Book.find(params[:id])
  end
end
