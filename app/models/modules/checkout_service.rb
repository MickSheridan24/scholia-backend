
module CheckoutService
  def get_formats(formats)
    retF = {}

    htmlF = find_html_format formats
    plainF = find_plain_format formats

    htmlF && retF["html"] = htmlF
    plainF && retF["plain"] = plainF

    retF
  end

  def find_html_format(formats)
    key = formats.keys.find do |k|
      k.starts_with?("text/html")
    end
    path = formats[key]
    if (path.ends_with?(".zip"))
      path = path.gsub(".zip", ".html")
    end

    path
  end

  def find_plain_format(formats)
    key = formats.keys.find do |k|
      k.starts_with?("text/plain")
    end
    path = formats[key]
    if (path.ends_with?(".zip"))
      path = path.gsub(".zip", ".txt")
    end

    path
  end

  def handle_html_book(path)
    sections = path && parse_html_sections(RestClient.get(path))
  end

  def handle_plain_book(path)
    plaintext = path && parse_plain_sections(RestClient.get(path))
  end

  def parse_plain_sections(plaintext)
    plaintext.split("\r\r").flatten.split("\n\n").map { |s| [plain: s, section_type: "plaintext"] }
  end

  def parse_html_sections(html)
    parsed = Nokogiri::HTML html
    sections = []
    sectionNodes = parsed.css("h1, h2, h3, h4, h5, p")

    order = 0
    sectionNodes.each do |node|
      if !node.content.blank?
        sections.push({ :html => node.content.strip, section_type: get_section_type(node), section_number: order })
        order += 1
      end
    end

    sections
  end

  def get_section_type(node)
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
