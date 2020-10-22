class AnnotationSerializer < Serializer
  def serialized
    serialize_with_attributes(:title, :location_char_index, :location_p_index, :body, :public, :color)
  end
end
