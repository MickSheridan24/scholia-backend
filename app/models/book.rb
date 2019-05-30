class Book < ApplicationRecord
  has_many :annotations

  #All steps in preparing book text before serving to the front end

  def self.fetch_book(id)
    req = RestClient.get("http://gutendex.com/books/#{id}")
    result = JSON(req)

    if (result)
      key = result["formats"].keys.find do |k|
        k.starts_with?("text/plain")
      end
    end

    secondReq = ""
    path = result["formats"][key]
    if (path.ends_with?(".zip"))
      path = path.gsub(".zip", ".txt")
    end

    secondReq = RestClient.get(path)
    text = JSON({body: secondReq})

    author = (result["authors"] && result["authors"][0] && result["authors"][0]["name"]) || "No Author"
    {title: result["title"], author: author, text: text}
  end

  def self.checkout(id)
    book = Book.find_by(gutenberg_id: id)
    if (book)
      return book
    else
      book = Book.fetch_book(id)
      checked_out = Book.create(title: book[:title], author: book[:author], gutenberg_id: id, temporary_text: book[:text])

      return checked_out
    end
  end

  def self.search_api(query)
    req = RestClient.get("http://gutendex.com/books?search=#{query}")
    search = JSON(req)
  end
end
