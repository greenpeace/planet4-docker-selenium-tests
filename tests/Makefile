
NGINX_HELPER_JSON := $(shell cat options/rt_wp_nginx_helper_options.json)

ifeq ($(SELENIUM_IMAGE),)
ifeq ($(CIRCLECI),true)
# Configure build variables based on CircleCI environment vars
SELENIUM_IMAGE = gcr.io/planet-4-151612/selenium:build-$(CIRCLE_BUILD_NUM)
else
# Not in CircleCI environment, try to set sane defaults
SELENIUM_IMAGE = gcr.io/planet-4-151612/selenium:build-local
endif
endif

.PHONY: all
all: clean run wait config test

.PHONY: clean
clean:
		docker-compose down -v --remove-orphans

.PHONY: run
run:
		SELENIUM_IMAGE=$(SELENIUM_IMAGE) \
		docker-compose up -d

.PHONY: wait
wait:
		docker-compose exec selenium wait_all_done 30s
		docker-compose exec selenium versions
		./wait.sh

.PHONY: config
config:
		@echo "Disabling Wordfence to improve test speed ..."
		docker-compose exec php-fpm wp plugin deactivate wordfence
		@echo "Configuring rewrite structure: /%category%/%post_id%/%postname%/"
		docker-compose exec php-fpm wp rewrite structure /%category%/%post_id%/%postname%/
		@echo "Configuring nginx-helper redis cache options ..."
		docker-compose exec php-fpm wp option set rt_wp_nginx_helper_options '$(NGINX_HELPER_JSON)' --format=json
		@echo "Setting p4 options ..."
		docker-compose exec -T php-fpm wp option update planet4_options --format=json < options/planet4_options.json
		@echo "Creating test_user ..."
		docker-compose exec php-fpm wp user create test_user noreply@greenpeace.org --role=administrator --user_pass="test_pass"
		@echo "Creating terms ..."
		docker-compose exec -T php-fpm bash < wp_terms.sh
		@echo "Creating a few posts ..."
		docker-compose exec -T php-fpm bash < wp_posts.sh
		@echo "Copying images ..."
		docker cp $(shell docker-compose ps -q selenium):/home/seluser/tests/data/images /tmp/images
		docker cp /tmp/images $(shell docker-compose ps -q php-fpm):/images
		docker-compose exec php-fpm sh -c 'wp media import /images/*'
		@echo "Flushing redis cache ..."
		docker-compose exec redis redis-cli flushdb

.PHONY: test
test: test-all

.PHONY: test-all
test-all:
		docker-compose exec selenium mkdir -p /tmp/test_output
		docker-compose exec selenium vendor/bin/phpunit --log-junit /tmp/test_output/junit.xml -c tests | tee output/output.txt
		mkdir -p output
		docker cp $(shell docker-compose ps -q selenium):/tmp/test_output/junit.xml output/junit.xml

.PHONY: test-exit-early
test-exit-early:
		docker-compose exec selenium mkdir -p /tmp/test_output
		docker-compose exec selenium vendor/bin/phpunit --stop-on-failure --log-junit /tmp/test_output/junit.xml -c tests | tee output/output.txt
		mkdir -p output
		docker cp $(shell docker-compose ps -q selenium):/tmp/test_output/junit.xml output/junit.xml
