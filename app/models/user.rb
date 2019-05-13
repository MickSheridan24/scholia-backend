class User < ApplicationRecord
  has_many :annotations
  has_many :likes
  has_many :subscribers
  has_many :contributors
end
