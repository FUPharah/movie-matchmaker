class AddImdbIdToMovies < ActiveRecord::Migration[7.0]
  def change
    add_column :movies, :imdb_id, :string
    add_index :movies, :imdb_id, unique: true
  end
end
