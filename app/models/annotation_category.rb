class AnnotationCategory < ApplicationRecord
  belongs_to :category
  belongs_to :annotation
end
