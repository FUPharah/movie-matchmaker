# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# db/seeds.rb

# Clear existing data
Genre.destroy_all
MoodTag.destroy_all
User.destroy_all

# puts 'creating genres'

# # Genres
# action = Genre.create!(name: 'Action')
# comedy = Genre.create!(name: 'Comedy')
# drama = Genre.create!(name: 'Drama')

# puts 'creating mood tags'
# # MoodTags
# happy = MoodTag.create!(name: 'Happy')
# sad = MoodTag.create!(name: 'Sad')
# exciting = MoodTag.create!(name: 'Exciting')

MOOD_TAGS = {
  Action: 'Exciting',
  Adventure: 'Adventurous',
  Animation: 'Imaginative',
  Biography: 'Inspirational',
  Comedy: 'Funny',
  Crime: 'Thrilling',
  Documentary: 'Informative',
  Drama: 'Emotional',
  Family: 'Heartwarming',
  Fantasy: 'Magical',
  'Film-Noir': 'Mysterious',
  History: 'Educational',
  Horror: 'Scary',
  Music: 'Energetic',
  Musical: 'Melodious',
  Mystery: 'Puzzling',
  Romance: 'Romantic',
  'Sci-Fi': 'Futuristic',
  Sport: 'Motivating',
  Thriller: 'Suspenseful',
  War: 'Intense',
  Western: 'Rugged'
}

MOOD_TAGS.each do |genre_name, mood_tag_name|
  genre = Genre.find_or_create_by!(name: genre_name.to_s)
  mood_tag = MoodTag.find_or_create_by!(name: mood_tag_name)
  genre.movies.update_all(mood_tag_id: mood_tag.id)
end

# puts 'creating users'
# # Users
# user1 = User.create!(
#   email: 'user1@example.com',
#   password: 'password',
#   password_confirmation: 'password'
# )

# user2 = User.create!(
#   email: 'user2@example.com',
#   password: 'password',
#   password_confirmation: 'password'
# )

# puts 'creating movies'
# # Movies
# movie1 = Movie.create!(
#   title: 'The Avengers',
#   poster_image_url: 'https://upload.wikimedia.org/wikipedia/en/8/8a/The_Avengers_%282012_film%29_poster.jpg',
#   release_date: '2012-05-04',
#   genre: action,
#   mood_tag: exciting
# )

# movie2 = Movie.create!(
#   title: 'The Shawshank Redemption',
#   poster_image_url: 'https://upload.wikimedia.org/wikipedia/en/8/81/ShawshankRedemptionMoviePoster.jpg',
#   release_date: '1994-10-14',
#   genre: drama,
#   mood_tag: sad
# )

# movie3 = Movie.create!(
#   title: 'The Hangover',
#   poster_image_url: 'https://upload.wikimedia.org/wikipedia/en/b/b9/Hangoverposter09.jpg',
#   release_date: '2009-06-05',
#   genre: comedy,
#   mood_tag: happy
# )

# puts 'creating ratings'
# # Ratings
# Rating.create!(user: user1, movie: movie1, score: 8)
# Rating.create!(user: user2, movie: movie1, score: 9)
# Rating.create!(user: user1, movie: movie2, score: 10)

# puts 'creating user_movie_lists'
# # UserMovieLists
# UserMovieList.create!(user: user1, movie: movie1, watchlist: 'true', favorites: 'false')
# UserMovieList.create!(user: user1, movie: movie2, watchlist: 'false', favorites: 'true')
# UserMovieList.create!(user: user2, movie: movie1, watchlist: 'true', favorites: 'true')
# UserMovieList.create!(user: user2, movie: movie3, watchlist: 'true', favorites: 'false')

# puts 'done'
