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

ARG DEPLOY_ENV
ENV RAILS_ENV=${DEPLOY_ENV}
ENV RAILS_SERVE_STATIC_FILES=true
# Redirect Rails log to STDOUT for Cloud Run to capture
ENV RAILS_LOG_TO_STDOUT=true
# [START cloudrun_rails_dockerfile_key]
ARG MASTER_KEY
ENV RAILS_MASTER_KEY=${MASTER_KEY}
# [END cloudrun_rails_dockerfile_key]

# # Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

RUN /usr/local/bundle/bin/bundle exec rake assets:precompile

# # # Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
