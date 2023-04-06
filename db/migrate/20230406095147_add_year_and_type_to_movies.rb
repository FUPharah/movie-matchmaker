class AddYearAndTypeToMovies < ActiveRecord::Migration[7.0]
  def change
    add_column :movies, :year, :integer
    add_column :movies, :type, :string
  end
end
