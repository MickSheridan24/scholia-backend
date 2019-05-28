class Study < ApplicationRecord
  has_many :annotations
  has_many :subscribers
  has_many :contributors

  def self.serialize_all
    self.all.sort do |l, h|
      h.annotations.length <=> l.annotations.length
    end.map do |s|
      s.serialize
    end
  end

  def serialize
    package = {name: self.name, description: self.description, color: self.color, id: self.id, annotation_count: self.annotations.length}
  end
end
