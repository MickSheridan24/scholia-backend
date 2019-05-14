class User < ApplicationRecord
  has_secure_password
  has_many :annotations
  has_many :likes
  has_many :subscribers
  has_many :contributors
end
