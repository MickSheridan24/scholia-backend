class SectionSerializer < Serializer
  attributes :id, :html, :plain, :section_type, :section_number
  has_many :annotations, true
end
