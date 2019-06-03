
class Api::V1::BooksController < ApplicationController

  #GET books/:gutenberg_id
  def show
    @book = Book.checkout(params[:id].to_i)
    render json: @book
  end

  #GET books/search?query=()
  def search
    @results = Book.search_api(search_params)

    if @results["count"] && @results["count"] > 0
      package = @results["results"].map do |book|
        {id: book["id"], title: book["title"], author: (book["authors"] && book["authors"].first && book["authors"].first["name"]) || "Author Not Found"}
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
