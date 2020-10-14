class Book < ApplicationRecord
  has_many :annotations
  has_many :sections

  #All steps in preparing book text before serving to the front end

  # Book.fetch_book
  # Fetches book from Gutenberg site
  def self.fetch_book(id)
    req = RestClient.get("http://gutendex.com/books/#{id}")
    result = JSON(req)

    formats = get_formats result["formats"] 

    sections = handle_html_book(formats["html"]) || handle_plain_book(formats["plain"])

    author = (result["authors"] && result["authors"][0] && result["authors"][0]["name"]) || "No Author"


    {title: result["title"], author: author, sections: sections}
  end

  # Book.checkout
  # Checks if book is in the database before fetching from database
  def self.checkout(id)
    book = Book.find_by(gutenberg_id: id)
    if (book)
      return book
    else
      book = Book.fetch_book(id)
      checked_out = Book.create(title: book[:title], author: book[:author], gutenberg_id: id)

      book[:sections].each do |s|
        sect = Section.create(html: s[:html], plain: s[:plain], type: s[:type])
        checked_out.sections.push sect
      end

      return checked_out
    end
  end

  # Book.search_api
  # Returns titles, authors, and ids based on a loose user search
  def self.search_api(query)
    req = RestClient.get("http://gutendex.com/books?search=#{query}")
    search = JSON req
  end
end


def get_formats formats 

  retF = {}

  htmlF = find_html_format formats 
  plainF = find_plain_format formats 

  htmlF && retF["html"] = htmlF
  plainF && retF["plain"] = plainF

  retF
end

def find_html_format formats 

  key = formats.keys.find do |k|
    k.starts_with?("text/html")
  end
  path = formats[key]
  if (path.ends_with?(".zip"))
    path = path.gsub(".zip", ".html")
  end

  path
end

def find_plain_format formats 

  key = formats.keys.find do |k|
    k.starts_with?("text/plain")
  end
  path = formats[key]
  if (path.ends_with?(".zip"))
    path = path.gsub(".zip", ".txt")
  end

  path
end


def handle_html_book path 
  sections = path && parse_html_sections(RestClient.get(path))
end

def handle_plain_book path
  plaintext = path && parse_plain_sections(RestClient.get(path))
end

def parse_plain_sections plaintext
  plaintext.split("\r\r").flatten.split("\n\n").map{ |s| [plain: s, type: "plain"]}
end

def parse_html_sections html
  parsed = Nokogiri::HTML html 

  sections = []

  sections.push [html: parsed.css("h1").first.content , type: "title"]

  sections.concat parsed.css("h2, h3, h4, h5").map{ |c| [html: c.content, type: "header"]}

  sections.concat parsed.css("p").map{ |c| [html: c.content, type: "paragraph"]}

  sections
end