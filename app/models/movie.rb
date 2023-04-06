class Movie < ApplicationRecord
  belongs_to :genre
  belongs_to :mood_tag
  has_many :ratings, dependent: :destroy
  has_many :user_movie_lists, dependent: :destroy
  has_many :users, through: :user_movie_lists, dependent: :destroy

  attr_accessor :title, :year, :imdb_id, :type, :poster_url, :genre, :mood_tag

  def initialize(attributes = {})
    @title = attributes[:title]
    @year = attributes[:year]
    @imdb_id = attributes[:imdb_id]
    @type = attributes[:type]
    @poster_url = attributes[:poster_url]
    @genre = attributes[:genre]
    @mood_tag = attributes[:mood_tag]
  end
end
