class FavoritesController < ApplicationController
  skip_before_action :verify_authenticity_token, if: :json_request?

  before_action :authenticate_api_request, if: :json_request?
  before_action :require_login, if: :html_request?
  before_action :ensure_current_user

  def index
    @favorites = current_user.favorite_movies
    @favorited_movie_ids = current_user.favorite_movies.pluck(:id)

    respond_to do |format|
      format.html
      format.json { render json: @favorites }
    end
  end

  def create
    movie = Movie.find(params[:movie_id])
    favorite = current_user.favorites.build(movie: movie)

    respond_to do |format|
      format.html do
        unless favorite.save
          flash[:error] = "Unable to add movie to favorites."
        end

        redirect_to movie_path(movie)
      end
      format.json do
        if favorite.save
          render json: { response: "Favorite successfully created", favorite: favorite }, status: :ok
        else
          render json: { response: "Invalid movie ID or favorite already exists", favorite: favorite }, status: :bad_request
        end
      end
    end
  end

  def destroy
    current_user.favorites.find_by(movie_id: params[:id]).destroy

    redirect_to movie_path(params[:id])
  end

  def toggle
    favorite = current_user.favorites.find_by(movie_id: params[:movie_id])

    if favorite
      favorite.destroy
    else
      current_user.favorites.create(movie_id: params[:movie_id])
    end

    referer_path = request.referer.include?(favorites_path) ? favorites_path : movies_path
    redirect_to referer_path
  end

  private

  def require_login
    unless current_user
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_path
    end
  end

  def ensure_current_user
    current_user ||= @current_user
  end
end
