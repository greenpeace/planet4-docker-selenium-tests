PLANET4_USER ?= dev
PLANET4_USER_PASS ?= u3vsREsvjwo

NGINX_HELPER_JSON := $(shell cat options/rt_wp_nginx_helper_options.json)

ifeq ($(CIRCLECI),true)
# Configure build variables based on CircleCI environment vars
BUILD_NUM = build-$(CIRCLE_BUILD_NUM)
else
# Not in CircleCI environment, try to set sane defaults
BUILD_NUM = build-local
endif

.PHONY: all
all: clean run wait config test

.PHONY: clean
clean:
		docker-compose down -v
		sudo rm -fr persistence

.PHONY: run
run:
		TEST_IMAGE=gcr.io/planet-4-151612/selenium:$(BUILD_NUM) \
		docker-compose up -d

.PHONY: wait
wait:
		time ./wait.sh

.PHONY: config
config:
		docker-compose exec php-fpm wp rewrite structure /%category%/%post_id%/%postname%/
		docker-compose exec php-fpm wp option set rt_wp_nginx_helper_options '$(NGINX_HELPER_JSON)' --format=json
		docker-compose exec php-fpm wp user create $(PLANET4_USER) noreply@greenpeace.org --role=administrator --user_pass="$(PLANET4_USER_PASS)"
		docker-compose exec redis redis-cli flushdb
		@echo
		@echo "*** Site ready at https://www.planet4.test and http://www.planet4.test"
		@echo "*** User: $(PLANET4_USER)"
		@echo "*** Pass: $(PLANET4_USER_PASS)"
		@echo

.PHONY: test
test:
		docker-compose exec test mkdir -p /tmp/test_output
		time docker-compose exec test vendor/bin/phpunit --log-junit /tmp/test_output/junit.xml -c tests | tee output/output.txt
		mkdir -p output
		docker cp tests_test_1:/tmp/test_output/junit.xml output/junit.xml
