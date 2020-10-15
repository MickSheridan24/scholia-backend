class Section < ApplicationRecord
    belongs_to :book
    has_many :annotations
end
