require 'httparty'

namespace :db do
  desc "Fetch 30 movies from the OMDb API and use them to seed the development database"
  task seed_movies: :environment do
    abort("This task is not meant to be run outside of development") unless Rails.env.development?

    api_key = 'fbb9e47c'
    url = "http://www.omdbapi.com/?apikey=#{api_key}&s=Movie&type=movie&page="

    puts "Fetching three pages of movies from OMDb, this may take a moment..."
    (1..3).each do |page|
      response = HTTParty.get("#{url}#{page}")

      if response.code == 200
        results = response.parsed_response["Search"]

        results.each do |result|
          movie_id = result["imdbID"]
          movie_response = HTTParty.get("http://www.omdbapi.com/?apikey=#{api_key}&i=#{movie_id}")

          if movie_response.code == 200
            movie = movie_response.parsed_response

            Movie.create!(
              title: movie["Title"],
              year: movie["Year"].to_i,
              details: movie["Plot"]
            )
          end
        end

        puts "Page #{page} fetched and imported"
      else
        puts "Error fetching movies: #{response.code}"
      end
    end
  end
end
