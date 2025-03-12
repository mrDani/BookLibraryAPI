class AuthorsController < ApplicationController
  def index
    @authors = Author.order(:name).page(params[:page]).per(10)
  end

  def show
    @author = Author.find(params[:id])
    @books = @author.books
  end
end
