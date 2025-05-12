ARG RUBY_VERSION=3.4.3
FROM ruby:${RUBY_VERSION}-slim

RUN mkdir -p /bundle /app

ENV BUNDLE_PATH=/bundle \
    RUBYOPT='-W:no-deprecated -W:no-experimental'

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    zlib1g-dev \
    libminizip-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock *.gemspec ./
COPY lib/fast_xlsx/version.rb lib/fast_xlsx/version.rb

RUN bundle install --jobs $(nproc)

COPY . .

CMD ["bundle", "exec", "rake", "build"]
