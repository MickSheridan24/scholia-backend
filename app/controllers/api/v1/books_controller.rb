
class Api::V1::BooksController < ApplicationController
  def show
    @book = Book.checkout(params[:id].to_i)
    render json: @book
  end

  def search
    @results = Book.search_api(search_params)

    if @results["count"] && @results["count"] > 0
      package = @results["results"].map do |book|
        {id: book["id"], title: book["title"], author: book["authors"].first["name"]}
      end
      render json: {success: true, results: package}
    else
      render json: {success: false}
    end
  end

  private

  def search_params
    params.require("query")
  end
end
