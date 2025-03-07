class GenresController < ApplicationController
  def index
    @genres = Genre.order(:name)
  end

  def show
    @genre = Genre.find(params[:id])
    @books = @genre.books.page(params[:page]).per(10)
  end
end
