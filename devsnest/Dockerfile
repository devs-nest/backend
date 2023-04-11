FROM ruby:3.0.6-alpine3.16
RUN apk update
RUN apk add \
  build-base \
  bash \
  mariadb-dev \
  tzdata \
  git \
  libsodium

RUN gem install bundler -v 2.4
COPY ./Gemfile  ./
COPY ./Gemfile.lock ./

RUN bundle install --without development test
COPY ./ ./
CMD ["bundle", "exec", "puma", "-e", "production"]
