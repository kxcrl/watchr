class MoviesController < ApplicationController
  def index
    if params[:search].present?
      @movies = Movie.search(params[:search]).records
    else
      @movies = Movie.all
    end

    @favorited_movie_ids = current_user&.favorite_movies&.pluck(:id) || []

    respond_to do |format|
      format.html
      format.json { render json: @movies }
    end
  end

  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @movie }
    end
  end
end
