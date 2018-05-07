FROM ruby:2.5.1

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# Set timezone
# RUN echo "US/Eastern" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
	build-essential \
	nodejs \
  lsof \
  graphviz \
  zlib1g-dev liblzma-dev wget unzip libgconf2-4 libnss3 nodejs \
  qt5-default \
	libqt5webkit5-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY Gemfile* ./
RUN gem install bundler
RUN gem install foreman
RUN bundle install
RUN rm -f tmp/pids/server.pid
COPY . .
