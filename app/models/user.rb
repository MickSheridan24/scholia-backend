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
    subscriptions = Study.where(name: ["Definitions", "Thematic Aspects", "Literary Analysis", "About The Author", "Historical Context"]);
   
    subscriptions.each do |subscr|
      Subscriber.create(user_id: self.id, study_id: subscr.id)
    end
    self.save
  end
end
