class CreateMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :poster_image_url
      t.date :release_date
      t.references :genre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
