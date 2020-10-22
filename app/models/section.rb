class Section < ApplicationRecord
  belongs_to :book
  has_many :annotations

  def serialized
    return SectionSerializer.new(self).serialized
  end

  def serializer
    return SectionSerializer.new(self)
  end
end
