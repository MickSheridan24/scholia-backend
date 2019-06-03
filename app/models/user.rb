class User < ApplicationRecord
  has_secure_password
  has_many :annotations
  has_many :likes
  has_many :subscribers
  has_many :studies, through: :subscribers
  has_many :contributors

  def create
    super
    self.default_subscriptions
  end

  # Automatically subscribes user to defaults upon creation
  def default_subscriptions
    subscriptions = [Study.find_by(name: "Definitions"), Study.find_by(name: "Thematic Aspects"), Study.find_by(name: "Literary Analysis"), Study.find_by(name: "About The Author"), Study.find_by(name: "Historical Context")]
    subscriptions.each do |s|
      Subscriber.create(user_id: self.id, study_id: s.id)
    end
    self.save
  end
end
