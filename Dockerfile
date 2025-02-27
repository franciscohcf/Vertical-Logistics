FROM ruby:3.4.1 AS base
WORKDIR /app
RUN apt-get update

FROM base AS dev
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install
