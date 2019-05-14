Book.destroy_all

def fetch_book(search)
  req = RestClient.get("http://gutendex.com/books?search=#{search}")
  req = JSON(req)
  result = req["results"][0]
  if (result && result.length > 0)
    key = result["formats"].keys.find do |k|
      k.starts_with?("text/html")
    end
  end

  secondReq = ""
  path = result["formats"][key]
  if (path.ends_with?(".htm") || path.ends_with?(".html") || path.ends_with?(".images"))
    secondReq = RestClient.get(path)
  else
    altered_path = path
    altered_path = altered_path.split(".")[0...-1].join(".")

    altered_path += "/#{result["id"]}-h.htm"

    secondReq = RestClient.get(altered_path)
  end

  secondReq = JSON({body: secondReq})

  secondReq
end

brothers = fetch_book("Brothers Karamazov")
common = fetch_book("Common Sense")
macbeth = fetch_book("Macbeth")

Book.create(title: "The Brothers Karamazov", author: "Fyodor Dostoevsky", gutenberg_id: 28054, temporary_text: brothers)
Book.create(title: "Common Sense", author: "Thomas Paine", gutenberg_id: 147, temporary_text: common)
Book.create(title: "Macbeth", author: "William Shakespeare", gutenberg_id: 2264, temporary_text: macbeth)

puts Book.all
