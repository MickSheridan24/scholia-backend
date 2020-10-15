class Contributor < ApplicationRecord
  belongs_to :study
  belongs_to :user
end
