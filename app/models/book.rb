require "modules/checkout_service"

class Book < ApplicationRecord
  extend CheckoutService


  has_many :annotations
  has_many :sections

  def serialized 
    BookSerializer.new(self).serialized
  end


  def self.fetch_book(id)
    req = RestClient.get("http://gutendex.com/books/#{id}")
    result = JSON(req)

    formats = get_formats result["formats"] 

    sections = handle_html_book(formats["html"]) || handle_plain_book(formats["plain"])

    author = (result["authors"] && result["authors"][0] && result["authors"][0]["name"]) || "No Author"


    {title: result["title"], author: author, sections: sections}
  end

  def self.checkout(id)
    book = Book.find_by(gutenberg_id: id)
    if (!book)
      book = Book.fetch_book(id)
      checked_out = Book.create(title: book[:title], author: book[:author], gutenberg_id: id)
      batch =  book[:sections].map do |sect|
        Section.new(html: sect[:html], 
                    plain: sect[:plain], 
                    section_type: sect[:section_type], 
                    section_number: sect[:section_number], 
                    book_id: checked_out.id)
      end
      Section.import batch
      book = checked_out
    end

    return {book: book.serialized}
  end

  def self.search_api(query)
    req = RestClient.get("http://gutendex.com/books?search=#{query}")
    search = JSON req
  end

end
