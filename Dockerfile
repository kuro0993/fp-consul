FROM ruby:3.1.2-alpine3.16

WORKDIR /app
ENV TZ Asia/Tokyo

RUN apk add --no-cache \
  alpine-sdk \
  vim \
  nodejs \
  mysql-dev \
  tzdata
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install
COPY . /app

# # Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# # # Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
