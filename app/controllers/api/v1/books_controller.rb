
class Api::V1::BooksController < ApplicationController
  def show
    @book = Book.find(params[:id])
    render json: @book
  end
end
