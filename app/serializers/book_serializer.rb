class BookSerializer < Serializer
  def serialized
    serialize_with_attributes(:title, :author, :gutenberg_id)
  end
end
