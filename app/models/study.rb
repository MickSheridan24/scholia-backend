class Study < ApplicationRecord
  has_many :annotations
  has_many :subscribers
  has_many :contributors
end
