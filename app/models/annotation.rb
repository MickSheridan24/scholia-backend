class Annotation < ApplicationRecord
  belongs_to :book
  belongs_to :user, optional: true
  belongs_to :study, optional: true
  has_many :likes
  has_many :annotation_categories
  has_many :categories, through: :annotation_categories

  # Annotation.allByBook
  # Finds and serializes all annotations with a specific book id
  def self.allByBook(user, id)
    if (id.is_a? Integer)
      annotations = Annotation.where(book_id: id).order(location_char_index: :desc)

      annotations.to_a.map { |a| Annotation.serialize(user, a, {by: :book}) }
    end
  end

  # Annotation.allByUser
  # Finds and serializes all annotations by user id
  def self.allByUser(user)
    annotations = Annotation.where(user_id: user.id).sort do |l, h|
      h.like_count <=> l.like_count
    end
    annotations.to_a.map { |a| Annotation.serialize(user, a, {by: :user}) }
  end

  # Annotation#like_count
  # returns like count
  def like_count
    return self.likes.length
  end

  # Annotation.serialize
  # packages annotation to be used by React App
  def self.serialize(user, annotation, options)
    like_count = annotation.likes.length

    userLiked = !!annotation.likes.find { |l| l.user_id == user.id }

    obj = annotation.attributes
    obj[:likeCount] = like_count

    if (options[:by] == :book)
      obj[:userLiked] = userLiked
    elsif (options[:by] == :user)
      obj[:book] = {title: annotation.book.title, author: annotation.book.author, id: annotation.book.id, gutenberg_id: annotation.book.gutenberg_id}
    end

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
