FROM ruby:3.0.3-bullseye AS base

RUN mkdir -p /bundle
RUN mkdir -p /app

ENV BUNDLE_PATH=/bundle

RUN apt-get update -qq && \
    apt-get install -y \
    zlib1g-dev \
    libminizip-dev \
    build-essential \
    && \
    apt-get clean

RUN gem update --system

WORKDIR /app

COPY . ./

RUN bundle install --jobs 2
ENV RUBYOPT='-W:no-deprecated -W:no-experimental'

CMD ["bundle", "exec", "rake", "build"]
