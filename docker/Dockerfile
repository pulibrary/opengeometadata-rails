FROM ubuntu:14.04
MAINTAINER Eliot Jordan <eliot.jordan@gmail.com>

RUN apt-get update && apt-get -y install \
    unzip \
    wget \
    git \
    curl \
    libpq-dev \
    postgresql-client \
    mysql-client \
    libmysqlclient-dev \
    libsqlite3-dev \
    sqlite3 \
    build-essential \
    make \
    libcurl4-openssl-dev \
    libreadline-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    libyaml-dev \
    zlib1g-dev \
    git-core \
    software-properties-common \
    python-software-properties \
    libgdbm-dev \   
    libncurses5-dev \
    automake \
    libtool \
    bison \
    libffi-dev

# Install ruby
RUN curl -O http://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz && \
    tar -zxvf ruby-2.1.2.tar.gz && \
    cd ruby-2.1.2 && \
    ./configure --disable-install-doc && \
    make && \
    make install && \
    cd .. && \
    rm -r ruby-2.1.2 ruby-2.1.2.tar.gz && \
    echo 'gem: --no-ri --no-rdoc' > /usr/local/etc/gemrcdoc

# Install java
# RUN apt-get -y install openjdk-7-jdk && \
#    mkdir /usr/java && \
#    ln -s /usr/lib/jvm/java-7-openjdk-amd64 /usr/java/default

# Install rails and gems
RUN gem install bundler && \
    gem install --no-ri --no-rdoc rails --version=4.2.0 && \
    gem install scss-lint

# Install nodejs and packages
# RUN apt-add-repository ppa:chris-lea/node.js -y && \
#    apt-get update -y && \
#    apt-get install nodejs -y && \
#    npm install -g bower && \
#    npm install -g grunt-cli && \
#    npm install -g gulp && \
#    npm install -g phantomjs

WORKDIR /usr/src/

# Install unicorn
RUN gem install unicorn && \
    mkdir /var/www /var/www/ogm /var/www/ogm/pids /var/www/ogm/log/

# Preload gems
RUN git clone https://github.com/pulibrary/opengeometadata-rails.git && \
    cd opengeometadata-rails && \
    echo "gem 'unicorn'" >> Gemfile && \
    bundle install

# Add scripts and config files
RUN mkdir /usr/scripts
ADD  unicorn.rb /usr/src/opengeometadata-rails/config/unicorn.rb
ADD . /usr/scripts

# make data directory
RUN mkdir /var/cache/opengeometadata

WORKDIR /usr/src/opengeometadata-rails

EXPOSE 3000
   
CMD bundle exec unicorn -c config/unicorn.rb