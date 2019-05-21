class Annotation < ApplicationRecord
  belongs_to :book
  belongs_to :user, optional: true
  belongs_to :study, optional: true
  has_many :likes
  has_many :annotation_categories
  has_many :categories, through: :annotation_categories

  def self.allByBook(user, id)
    if (id.is_a? Integer)
      sql = "SELECT * FROM annotations WHERE book_id = #{id} ORDER BY location_char_index DESC"
      ret = ActiveRecord::Base.connection.execute(sql).to_a

      ret.to_a.map { |a| Annotation.serialize(user, a, {}) }
    end
  end

  def self.serialize(user, annotation, options)
    anno = Annotation.find(annotation["id"])
    likeCount = anno.likes
    userLiked = anno.likes.find { |l| l.user_id == user.id }
    obj = annotation.dup
    obj[:likeCount] = likeCount
    obj[:userLiked] = userLiked
    obj
  end
end
