class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :user_movie_lists
  has_many :movies, through: :user_movie_lists
  has_many :favorites, through: :user_movie_lists
  has_many :watchlists, through: :user_movie_lists
  has_many :user_movie_list_favorites, through: :user_movie_lists
  has_many :user_movie_list_watchlists, through: :user_movie_lists
end
