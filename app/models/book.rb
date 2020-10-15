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
      return {book: book, sections: book.sections}
    else
      book = Book.fetch_book(id)
      checked_out = Book.create(title: book[:title], author: book[:author], gutenberg_id: id)

      book[:sections].each do |sect|
        sect = Section.create(html: sect[:html], 
                              plain: sect[:plain], 
                              section_type: sect[:section_type], 
                              section_number: sect[:section_number])
        checked_out.sections.push sect
      end

      return {book: checked_out, sections: checked_out.sections}
    end
  end

  # Book.search_api
  # Returns titles, authors, and ids based on a loose user search
  def self.search_api(query)
    req = RestClient.get("http://gutendex.com/books?search=#{query}")
    search = JSON req
  end

  def self.get_formats formats 

    retF = {}

    htmlF = find_html_format formats 
    plainF = find_plain_format formats 

    htmlF && retF["html"] = htmlF
    plainF && retF["plain"] = plainF

    retF
  end

  def self.find_html_format formats 

    key = formats.keys.find do |k|
      k.starts_with?("text/html")
    end
    path = formats[key]
    if (path.ends_with?(".zip"))
      path = path.gsub(".zip", ".html")
    end

    path
  end

  def self.find_plain_format formats 

    key = formats.keys.find do |k|
      k.starts_with?("text/plain")
    end
    path = formats[key]
    if (path.ends_with?(".zip"))
      path = path.gsub(".zip", ".txt")
    end

    path
  end


  def self.handle_html_book path 
    sections = path && parse_html_sections(RestClient.get(path))
  end

  def self.handle_plain_book path
    plaintext = path && parse_plain_sections(RestClient.get(path))
  end

  def self.parse_plain_sections plaintext
    plaintext.split("\r\r").flatten.split("\n\n").map{ |s| [plain: s, section_type: "plaintext"]}
  end

  def self.parse_html_sections html
    parsed = Nokogiri::HTML html 
    sections = []
    sectionNodes = parsed.css("h1, h2, h3, h4, h5, p")

    order = 0;
    sectionNodes.each do |node| 
      if !node.content.blank?
        sections.push({:html => node.content.strip, section_type: get_section_type(node), section_number: order})
        order += 1
      end
    end

    sections
  end


  def self.get_section_type node 

    case node.name
      when "h1"
        return "title"
      when "h2", "h3", "h4", "h5"
        return "header"
      when "p"
        return "paragraph"
      else
      return "plaintext"
    end
  end

end
