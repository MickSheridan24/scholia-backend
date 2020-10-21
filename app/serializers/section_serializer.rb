require "serializer"

class SectionSerializer < Serializer
  extend Serializer::Attributes
  include Serializer::Model
 
  
  attributes :id, :html, :plain, :section_type, :section_number
  has_many :annotations, true
end
