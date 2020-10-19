class BookSerializer < Serializer
  attributes :title, :author, :gutenberg_id
  has_many :sections, true
end
