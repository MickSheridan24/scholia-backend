class Book < ApplicationRecord
  has_many :annotations

  #All steps in preparing book text before serving to the front end

  def self.fetch_book(search)
    req = Nokogiri::HTML(open("http://gutendex.com/books?search=#{search}"))
    search = JSON(req)
    result = search["results"][0]
    if (result)
      key = result["formats"].keys.find do |k|
        k.starts_with?("text/html")
      end
      if (key)
        textReq = ""
        path = result["formats"][key]
        if (path.ends_with?(".htm") || path.ends_with?(".html") || path.ends_with?(".images"))
          textReq = Nokogiri::HTML(open(path))
        else
          altered_path = path
          altered_path = altered_path.split(".")[0...-1].join(".")
          altered_path += "/#{result["id"]}-h.htm"
          textReq = Nokogiri::HTML(open(altered_path))
        end

        return textReq
      end
    else
      return false
    end
  end

  #remove any scripts
  #attach body to div
  def self.sanitize(nokoText)
    doc = nokoText.at_css("body")
    doc.node_name = "div"
    doc.set_attribute("id", "text-body")
    doc.search("style, script, meta").remove

    doc.to_html
  end

  def prepare(search)
    text = Book.fetch_book(self.title)
    text = Book.sanitize(text)
    self.temporary_text = text
    self.save
  end
end
