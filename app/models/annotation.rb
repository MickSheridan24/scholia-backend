class Annotation < ApplicationRecord
  belongs_to :book
  belongs_to :user
  belongs_to :study
  has_many :likes
  has_many :annotation_categories
  has_many :categories, through: :annotation_categories
end
