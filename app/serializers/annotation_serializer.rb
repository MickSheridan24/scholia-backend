require "serializer"

class AnnotationSerializer < Serializer
  extend Serializer::Attributes
  include Serializer::Model
  

  attributes :title, :location_char_index, :location_p_index, :body, :public, :color
end


