
class Api::V1::BooksController < ApplicationController
  def show
    @book = Book.all[params[:id].to_i]
    render json: @book
  end
end
