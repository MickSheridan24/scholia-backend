class Annotation < ApplicationRecord
  belongs_to :book
  belongs_to :user
  belongs_to :study, optional: true
  has_many :likes
  has_many :annotation_categories
  has_many :categories, through: :annotation_categories

  def self.allByBook(id)
    if (id.is_a? Integer)
      sql = "SELECT * FROM annotations WHERE book_id = #{id}"
      ret = ActiveRecord::Base.connection.execute(sql).to_a
    end
  end
end
