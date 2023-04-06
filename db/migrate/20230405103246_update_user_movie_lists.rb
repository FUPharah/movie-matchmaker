
class UpdateUserMovieLists < ActiveRecord::Migration[7.0]
  def change
    remove_column :user_movie_lists, :watchlist
    remove_column :user_movie_lists, :favorites

    add_column :user_movie_lists, :is_favorite, :boolean, default: false
  end
end
