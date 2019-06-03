class Study < ApplicationRecord
  has_many :annotations
  has_many :subscribers
  has_many :contributors

  # Study.serialize_all
  # Gets all studies sorted by annotation count
  def self.serialize_all(user)
    self.all.sort do |l, h|
      h.annotations.length <=> l.annotations.length
    end.map do |s|
      s.serialize(user)
    end
  end

  # Study#userSubscribed
  def userSubscribed(user)
    Subscriber.where(user_id: user[:id], study_id: self.id).first
  end

  # Study#serialize
  # packages studies along with whether a user has subscribed to it
  def serialize(user)
    user_subscribed = Subscriber.where(user_id: user.id, study_id: self.id).first
    package = {name: self.name, description: self.description, color: self.color, id: self.id, annotation_count: self.annotations.length, userSubscribed: user_subscribed}
  end
end
