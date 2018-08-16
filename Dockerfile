FROM elgalu/selenium:3
LABEL \
  author=kyriakos.diamantis@greenpeace.org \
  maintainer=raymond.walker@greenpeace.org

USER root

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get -y install \
    libmcrypt-dev \
    libxml2-dev \
    php \
    php-cli \
    php-curl \
    php-json \
    php-mbstring \
    php-mcrypt \
    php-mysql \
    php-mysql \
    php-pdo \
    php-xml \
    php-zip \
    && \
    rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/* && \
    curl --connect-timeout 5 --max-time 10 --retry 5 --retry-delay 0 --retry-max-time 60 -OSL https://github.com/jwilder/dockerize/releases/download/v0.6.1/dockerize-linux-amd64-v0.6.1.tar.gz && \
    tar xzf dockerize-linux-amd64-v0.6.1.tar.gz && mv dockerize /usr/local/bin && rm dockerize-linux-amd64-v0.6.1.tar.gz

COPY bin/entrypoint.sh /entrypoint.sh
COPY bin/add_test_domain_to_hosts.sh /usr/local/bin/add_test_domain_to_hosts.sh
COPY bin/clean_defunct_windows.sh /usr/local/bin/clean

EXPOSE 5900

USER seluser

COPY --chown=seluser:seluser src .

COPY config.php.tmpl /home/seluser/config/config.php.tmpl

ENTRYPOINT [ "/entrypoint.sh" ]

CMD [ "/usr/bin/entry.sh" ]

ENV \
  BROWSER="chrome" \
  EMAIL_PASS="u3vsREsvjwo" \
  EMAIL_USER="tester.greenwire@gmail.com" \
  PATH="~/tests/vendor/bin:$PATH" \
  P4_PASS="u3vsREsvjwo" \
  P4_PROTO="http" \
  P4_DOMAIN="www.planet4.test" \
  P4_USER="dev" \
  SELENIUM_PORT="24444" \
