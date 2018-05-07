FROM elgalu/selenium
LABEL author=kyriakos.diamantis@greenpeace.org

ENV PLANET4_SELENIUM_URL https://github.com/greenpeace/planet4-selenium-tests

USER root

RUN apt update && apt -y install \
    libmcrypt-dev \
    libxml2 \
    libxml2-dev \
    php \
    php-cli \
    php-curl \
    php-mbstring \
    php-mcrypt \
    php-pdo \
    php-mysql \
    php-json \
    php-zip \
    php-mysql \
    php-xml \
    curl \
    git \
    mysql-client \
    nano \
    vim \
    iputils-ping && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/bin/composer

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