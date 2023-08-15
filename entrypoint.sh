#!/bin/bash
set -e

bin/rails db:create
bin/rails db:migrate
bin/rake db:seed_movies
bin/rails runner "Movie.__elasticsearch__.create_index!"
bin/rails runner "Movie.import"

exec "$@"
