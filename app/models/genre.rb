class Genre < ApplicationRecord
  has_many :movies, dependent: :destroy
end
