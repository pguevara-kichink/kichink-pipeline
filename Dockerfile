FROM debian:jessie-slim
MAINTAINER Paulo Guevara <paulo.guevara@gmail.com>

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US:en

#Install PHP MySql
RUN \
 apt-get update &&\
 apt-get -y --no-install-recommends install locales apt-utils &&\
 echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen &&\
 locale-gen en_US.UTF-8 &&\
 /usr/sbin/update-locale LANG=en_US.UTF-8 &&\
 echo "mysql-server mysql-server/root_password password root" | debconf-set-selections &&\
 echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections &&\
 apt-get -y --no-install-recommends install ca-certificates unzip openssl git subversion php5-mysqlnd php5-cli php5-sqlite php5-mcrypt php5-curl php5-intl php-gettext php5-json php5-geoip php5-apcu php5-gd php5-imagick php5-xdebug php5-xhprof php5-xmlrpc imagemagick openssh-client curl software-properties-common gettext zip mysql-server mysql-client apt-transport-https ruby python python3 perl php5-memcached memcached &&\
 curl -sSL https://deb.nodesource.com/setup_4.x | bash - &&\
 apt-get -y --no-install-recommends install nodejs &&\
 apt-get autoclean && apt-get clean && apt-get autoremove

RUN \
 sed -ri -e "s/^variables_order.*/variables_order=\"EGPCS\"/g" /etc/php5/cli/php.ini &&\
 echo "xdebug.max_nesting_level=250" >> /etc/php5/mods-available/xdebug.ini

#Install Composer PhpUnit Codeception
RUN \
 curl -sSL https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin &&\
 curl -sSL https://phar.phpunit.de/phpunit-5.7.phar -o /usr/bin/phpunit  && chmod +x /usr/bin/phpunit  &&\
 curl -sSL http://codeception.com/codecept.phar -o /usr/bin/codecept && chmod +x /usr/bin/codecept &&\
 npm install --no-color --production --global gulp-cli webpack mocha grunt &&\
 rm -rf /root/.npm /root/.composer /tmp/* /var/lib/apt/lists/*

#Install JAVA 8
RUN touch /etc/apt/sources.list.d/java-8-debian.list
RUN sh -c 'echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list.d/java-8-debian.list'
RUN sh -c 'echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list.d/java-8-debian.list'
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
RUN apt-get update
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN apt-get install -y oracle-java8-installer
RUN apt-get install -y oracle-java8-set-default
RUN java -version

#Install Sonar Scanner
RUN curl --insecure -OL https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-2.6.1.zip
RUN unzip sonar-scanner-2.6.1.zip
RUN chmod a+x ./sonar-scanner-2.6.1/bin/sonar-scanner
RUN echo “Sonar pipeline, baby!”
