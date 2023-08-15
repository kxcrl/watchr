FROM ruby:3.2.1 as app
RUN apt-get update -qq && apt-get install -y postgresql-client
WORKDIR /server
COPY . .
RUN bundle install
RUN bundle exec rails assets:precompile

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
CMD ["bin/rails", "server", "-p", "3000", "-b", "'0.0.0.0'"]
