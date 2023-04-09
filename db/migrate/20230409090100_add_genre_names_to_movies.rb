class AddGenreNamesToMovies < ActiveRecord::Migration[7.0]
  def change
    add_column :movies, :genre_names, :string
  end
end
