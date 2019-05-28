class Annotation < ApplicationRecord
  belongs_to :book
  belongs_to :user, optional: true
  belongs_to :study, optional: true
  has_many :likes
  has_many :annotation_categories
  has_many :categories, through: :annotation_categories

  def self.allByBook(user, id)
    if (id.is_a? Integer)
      annotations = Annotation.where(book_id: id).order(location_char_index: :desc)

      annotations.to_a.map { |a| Annotation.serialize(user, a, {}) }
    end
  end

  def self.serialize(user, annotation, options)
    likeCount = annotation.likes.length

    userLiked = !!annotation.likes.find { |l| l.user_id == user.id }

    obj = annotation.attributes
    obj[:likeCount] = likeCount
    obj[:userLiked] = userLiked

    if (obj["study_id"] != nil)
      study = Study.find(obj["study_id"])
      obj[:study] = {}
      obj[:study][:name] = study[:name]
      obj[:study][:description] = study[:description]
      obj[:study][:color] = study[:color]
      obj[:study][:id] = study[:id]
    end

    obj
  end
end
