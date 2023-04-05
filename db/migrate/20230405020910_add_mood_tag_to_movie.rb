class AddMoodTagToMovie < ActiveRecord::Migration[7.0]
  def change
    add_reference :movies, :mood_tag, null: false, foreign_key: true
  end
end
