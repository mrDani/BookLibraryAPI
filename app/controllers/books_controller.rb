class BooksController < ApplicationController
  def index
    @books = if params[:search]
               Book.where("title ILIKE ?", "%#{params[:search]}%")
             else
               Book.order(:title).page(params[:page]).per(10)
             end
  end

  def show
    @book = Book.find(params[:id])
  end
end
