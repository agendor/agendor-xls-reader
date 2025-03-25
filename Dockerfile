FROM ruby:3.2.5-bullseye AS base

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

RUN gem update --system 3.5.23

WORKDIR /app

COPY . ./

RUN bundle install --jobs $(nproc)
ENV RUBYOPT='-W:no-deprecated -W:no-experimental'

CMD ["bundle", "exec", "rake", "build"]
