FROM ruby:3.1.2-alpine3.16

WORKDIR /app
ENV TZ=Asia/Tokyo
ENV BUNDLER_VERSION=2.3.10

RUN apk add --no-cache \
  alpine-sdk \
  vim \
  mysql-dev \
  tzdata
  # nodejs \
  # npm \
# RUN npm install --global yarn

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN gem install bundler -v ${BUNDLER_VERSION}
RUN bundle install

COPY . /app

# # Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# # # Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
