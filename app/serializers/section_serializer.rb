class SectionSerializer < Serializer
  def serialized
    serialize_with_attributes(:id, :html, :plain, :section_type, :section_number)
  end
end
