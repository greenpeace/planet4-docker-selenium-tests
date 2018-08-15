FROM elgalu/selenium:3.1
LABEL author=kyriakos.diamantis@greenpeace.org

ENV PLANET4_SELENIUM_URL https://github.com/greenpeace/planet4-selenium-tests

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

RUN echo "root:secret" | chpasswd
RUN git clone $PLANET4_SELENIUM_URL /var/www/tests
WORKDIR /var/www/tests
COPY conf/selenium_config.php /var/www/config.php.example
COPY bin/entrypoint.sh /entrypoint.sh
COPY bin/add_test_domain_to_hosts.sh /add_test_domain_to_hosts.sh
COPY bin/clean_defunct_windows.sh /usr/bin/clean
RUN chmod 755 /usr/bin/clean && \
    chown -R seluser:seluser /var/www/tests /entrypoint.sh /add_test_domain_to_hosts.sh /var/www/config.php.example
USER seluser
RUN composer install

CMD [ "/entrypoint.sh" ]
EXPOSE 5900
