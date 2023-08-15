# WATCHR

Finally, an app that lets you keep track of your favorite movies.


## Quick Start

Simply run the included Docker compose script and navigate to localhost:3000

```bash
docker-compose up -d --build
```

Once there, you'll be able to create an account, log in, and begin using the
application.

## API

Watchr includes a JSON API with the following endpoints: \
`GET /movies.json?search={search}` - search for movies by title \
`GET /movies/:id.json` - get details about a specific movie \
`GET /favorites.json` - see your favorites \
`POST /favorites/:id.json` - add a favorite

Anyone can access the movie database, but favorites are specific to your
account. In order to view them, you'll first need to authenticate by sending
a POST request to `/authenticate?email=your_email&password=your_password`

You'll receive a response with
`{"auth_token":"a_long_string_of_letters_and_numbers"}`

You can now use this auth token by including it in the `Authorize` header of
your requests. Without this header, any API calls will be rejected with an
authorization error.

## The Movie Database

You may have noticed we have a pretty amazing movie selection, truly unrivaled
elsewhere. Well, it's not ours. It comes from OMDb.

If you'd like to make adjustments to the types of movies or how many of them are
available, you can simply edit `lib/tasks/db_seed.rake`.

By default, Watchr includes a generic, free OMDb account. This only allows 1000
movies to be queried per day, though, so it has to be used sparingly. In order
to add more movies to your own Watchr application, sign up for an OMDb account,
update the `api_key` variable, and increase the number of pages that are
fetched.

## Search functionality

In order to provide robust, scalable search with a wide variety of options,
Watchr uses Elasticsearch. This is included in `docker-compose.yml`, and any
cluster settings that you'd like to adjust can be changed there.

## Running without Docker

You shouldn't do this. But you can. And maybe you have reasons.

Run Postgres:
```bash
docker run -d --name pg -e POSTGRES_PASSWORD=postgres -p 5432:5432 postgres
```

Run Elasticsearch:
```bash
docker run --name es \
  --publish 9200:9200 \
  --publish 9300:9300 \
  --env "discovery.type=single-node" \
  --env "cluster.name=movies" \
  --env "cluster.routing.allocation.disk.threshold_enabled=false" \
  --env "ES_JAVA_OPTS=-Xms512m -Xmx512m" \
  docker.elastic.co/elasticsearch/elasticsearch:7.17.7
```

Note that Elasticsearch versioning is complex, to say the least. We are running
the 7.2.1 version of the Rails gem, but the version we need to match is the
version of elasticsearch-ruby, which is an implicit dependency that you have to
check the Gemfile.lock file for the version of.

Since you're not running Docker Compose, you'll need to manually setup the
database and the elasticsearch indices. Typically, this is handled by
entrypoint.sh, which you can either make executable and run in its entirety or
simply execute each of the commands from inside of it:

```bash
bin/rails db:create
bin/rails db:migrate
bin/rake db:seed_movies
bin/rails runner "Movie.__elasticsearch__.create_index!"
bin/rails runner "Movie.import"
```

Next, you'll need to remove the Docker networking for Postgres and
Elasticsearch in `config/database.yml` and
`config/initializers/elasticsearch.rb`, respectively. For ease of development,
these changes are already included and only have to be uncommented to take
effect.

With all of this in place, you should now be able to start Rails with
`./bin/dev` as usual, visit `localhost:3000`, and access the application.


## Development

Several development tools are included, namely `pry-byebug` for debugging and
`rspec` for testing. While most of the existing functionality depends on Rails
core or its associated gem libraries and is outside of the bounds of most
tests, some guards are in place around authorization and favoriting logic. You
can run them at anytime with the `rspec` command. To run a specific file and
line number, for example the Favorites Request spec to test adding favorites,
you can use the following syntax:

```bash
rspec ./spec/requests/favorites_spec.rb:11
```

Note that while Elasticsearch isn't needed for tests, you will need a Postgres
database available at `localhost:5432`. You'll also need to update
`config/database.yml` as above to run the app without containerization.

## What's next

There are many fundamental ways that Watchr could improve. Here's our current
roadmap:

    1. Escape the clutches of the Hollywood elite and add support for
       importing your own movies.
    2. Get more information for the movies that we do have. Wouldn't a little
       cover art be nice?
    3. Add different levels of ranking since, after all, nothing is as simple
       as "favorite" in this wild and diverse world.
