class Like < ApplicationRecord
  belongs_to :annotation
  belongs_to :user
end
