Book.destroy_all

def fetch_book(search)
  req = RestClient.get("http://gutendex.com/books?search=#{search}")
  req = JSON(req)
  result = req["results"][0]
  if (result && result.length > 0)
    key = result["formats"].keys.find do |k|
      k.starts_with?("text/plain")
    end
  end

  secondReq = ""
  path = result["formats"][key]
  # if (path.ends_with?(".htm") || path.ends_with?(".html") || path.ends_with?(".images"))
  #   secondReq = RestClient.get(path)
  # else
  #   altered_path = path
  #   altered_path = altered_path.split(".")[0...-1].join(".")

  #   altered_path += "/#{result["id"]}-h.htm"

  #   secondReq = RestClient.get(altered_path)
  # end

  secondReq = RestClient.get(path)
  text = JSON({body: secondReq})

  # paragraphs = text.split("\\r\\n\\r\\n")

  # paragraphs = paragraphs.map do |par|
  #   par = par.gsub("\\r\\n", " ")
  # end
  # paragraphs[0] = paragraphs[0][9...-1]
  # paragraphs[-1] = paragraphs[-1][0..-3]

  # JSON({text: paragraphs})
  text
end

brothers = fetch_book("Pride and Prejudice")
byebug
common = fetch_book("Sonnets")
macbeth = fetch_book("Iliad")

Book.create(title: "Pride and Prejudice", author: "Jane Austin", gutenberg_id: 28054, temporary_text: brothers)
Book.create(title: "Sonnets", author: "William Shakespeare", gutenberg_id: 147, temporary_text: common)
Book.create(title: "Iliad", author: "Homer", gutenberg_id: 2264, temporary_text: macbeth)

puts Book.all
