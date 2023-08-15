require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  let(:movie_attributes) do
    {
      title: 'A Movie About Tests',
      year: 1999,
      details: 'Truly one of the most riveting events of the year.'
    }
  end

  let(:user_attributes) do
    {
      email: 'test@test.com',
      password: 'supersecure'
    }
  end

  let(:movie) { Movie.create! movie_attributes }
  let(:user) { User.create! user_attributes }

  before do
    allow_any_instance_of(::FavoritesController).to receive(:authenticate_api_request) { user }
    allow_any_instance_of(::FavoritesController).to receive(:current_user) { user }
  end

  describe "GET /index" do
    it "returns http success" do
      get "/favorites.json"
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /create" do
    describe "with a correct movie id" do
      it "creates a new favorite" do
        expect {
          post "/favorites/#{movie.id}.json"
        }.to change(Favorite, :count).by(1)
      end
    end

    describe "when a favorite already exists" do
      it "creates a new favorite" do
        Favorite.create! user_id: user.id, movie_id: movie.id

        expect {
          post "/favorites/#{movie.id}.json", params: { movie_id: movie.id }
        }.to change(Favorite, :count).by(0)
      end
    end
  end
end
