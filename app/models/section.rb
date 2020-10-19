class Section < ApplicationRecord
    belongs_to :book
    has_many :annotations

    def serialized 
        SectionSerializer.new(self).serialized
    end
end
