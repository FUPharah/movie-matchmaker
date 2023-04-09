class RemoveGenreIdFromMovies < ActiveRecord::Migration[7.0]
  def change
    remove_column :movies, :genre_id
  end
end
