class CreateUserMovieLists < ActiveRecord::Migration[7.0]
  def change
    create_table :user_movie_lists do |t|
      t.string :watchlist
      t.string :favorites
      t.references :user, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true

      t.timestamps
    end
  end
end
