class RatingsController < ApplicationController
  def create
    @movie = Movie.find(params[:movie_id])
    @rating = Rating.new(rating_params)
    @rating.movie = @movie
    @rating.user = current_user
    if @rating.save
      redirect_to movie_path(@movie)
    else
      render 'movies/show', status: :unprocessable_entity
    end
  end

  def update
    @movie = Movie.find(params[:movie_id])
    @rating = Rating.find(params[:id])
    if @rating.update(rating_params)
      redirect_to movie_path(@movie)
    else
      render 'movies/show', status: :unprocessable_entity
    end
  end
end
