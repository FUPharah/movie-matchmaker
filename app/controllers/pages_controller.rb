class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    if params[:search]
      @movies = OmdbService.search_movies(params[:search])
      flash.now[:warning] = "No results found for '#{params[:search]}'" if @movies.empty?
    else
      @movies = OmdbService.search_movies('American Pie')
    end
  end
end
