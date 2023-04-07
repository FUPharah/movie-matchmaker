class AddWatchlistToUserMovieLists < ActiveRecord::Migration[7.0]
  def change
    add_column :user_movie_lists, :watchlist, :boolean, default: false
  end
end
