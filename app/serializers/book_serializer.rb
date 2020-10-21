require "serializer"

class BookSerializer 
  extend Serializer::Attributes 
  include Serializer::Model

  attributes :title, :author, :gutenberg_id
  has_many :sections, true
end
