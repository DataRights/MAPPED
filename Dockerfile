FROM ruby:2.3

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# Set timezone
RUN echo "US/Eastern" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
	build-essential \
	nodejs \
	qt5-default \
	libqt5webkit5-dev \
	gstreamer1.0-plugins-base \
	gstreamer1.0-tools \
	gstreamer1.0-x \
  lsof \
  graphviz \
  zlib1g-dev liblzma-dev wget xvfb unzip libgconf2-4 libnss3 nodejs \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app


COPY Gemfile* ./
RUN gem install bundler
RUN bundle install
RUN rm -f tmp/pids/server.pid
COPY . .
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
