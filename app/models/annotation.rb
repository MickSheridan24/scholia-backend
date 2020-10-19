class Annotation < ApplicationRecord
  belongs_to :book
  belongs_to :user, optional: true
  belongs_to :study, optional: true
  belongs_to :section
  has_many :likes
  has_many :annotation_categories
  has_many :categories, through: :annotation_categories


  def self.allByBook(user, id)
    if (id.is_a? Integer)
      annotations = Annotation.where(book_id: id).order(location_char_index: :desc)

      annotations.to_a.map { |a| Annotation.serialize(user, a, {by: :book}) }
    end
  end

  def self.allByUser(user)
    annotations = Annotation.where(user_id: user.id).sort do |l, h|
      h.like_count <=> l.like_count
    end
    annotations.to_a.map { |a| Annotation.serialize(user, a, {by: :user}) }
  end


  def like_count
    return self.likes.length
  end

  def serialized 
    AnnotationSerializer.new(self).serialized
  end
end
