FROM ruby:2.7.2-alpine3.13
RUN apk update
RUN apk add \
    build-base \
    bash \
    mariadb-dev \
    tzdata \
    git \
    libsodium

RUN gem install bundler
COPY ./Gemfile  ./
COPY ./Gemfile.lock ./

RUN bundle install --without development test
COPY ./ ./
CMD ["bundle", "exec","puma"]
