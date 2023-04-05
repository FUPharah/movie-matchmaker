class CreateMoodTags < ActiveRecord::Migration[7.0]
  def change
    create_table :mood_tags do |t|
      t.string :name

      t.timestamps
    end
  end
end
