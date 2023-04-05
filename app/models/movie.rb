class Movie < ApplicationRecord
  belongs_to :genre
  belongs_to :mood_tag
  has_many :ratings
  has_many :user_movie_lists
  has_many :users, through: :user_movie_lists
end
