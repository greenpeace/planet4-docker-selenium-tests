# Greenpeace Planet4 selenium tests docker image

![Planet4](https://cdn-images-1.medium.com/letterbox/300/36/50/50/1*XcutrEHk0HYv-spjnOej2w.png?source=logoAvatar-ec5f4e3b2e43---fded7925f62)

## What is Planet4?

Planet4 is the NEW Greenpeace web platform

## What is this repository?

This repository contains a docker image to set up a docker container that contains [planet4-selenium-tests](https://github.com/greenpeace/planet4-selenium-tests) and the needed tools to run these tests.
The image is based on [elgalu/selenium](https://github.com/elgalu/docker-selenium)

## How to set up the docker environment

### Requirements

Requirements for running this testing environment:

  * [docker](https://docs.docker.com/engine/installation/)
  * [docker-compose](https://docs.docker.com/engine/installation/)
  * [make](https://www.gnu.org/software/make/)

Optionally

### Quickstart
Assuming a [Planet4 docker-compose environment](https://github.com/greenpeace/planet4-docker-compose) is accessible at `http://www.planet4.test`:

```bash
# Clone this repo
git clone https://github.com/greenpeace/planet4-docker-selenium-tests
cd planet4-docker-selenium-tests

# Start Selenium grid
make

# Execute tests
make exec
```

### Development
1. Clone the source files from https://github.com/greenpeace/planet4-selenium-tests
   ```bash
      make src
    ```
1. Build the image
    ```bash
      make build
    ```
1. Start the container
    ```bash
      # Defaults
      make run
    ```
    See `docker-compose.yml` for customisations. For example, to change the host, username and password for authenticating
    ```bash
    P4_DOMAIN=k8s.p4.greenpeace.org P4_USER=test P4_PASS=test_pass make run
    ```
1. Run tests using the provided `make exec` command:
    ```bash
      # Run all tests
      make exec
      # or
      docker exec p4_selenium_1 vendor/bin/phpunit -c tests

      # Run only a single test
      make exec EXEC="vendor/bin/phpunit tests/p4/Articles.php"
      # or
      docker exec p4_selenium_1 vendor/bin/phpunit tests/p4/Articles.php
      # or
      docker-compose exec selenium vendor/bin/phpunit tests/p4/Articles.php

    ```
    Or using [gulp](https://gulpjs.com/) to monitor the src/ folder and automatically rerun tests every time a file changes (NodeJS required):
    ```bash
      gulp
    ```
1. (Optional) If you need to see the actual browser running the tests, you will need a vnc client.
 A choice would be ([RealVnc](https://www.realvnc.com/en/connect/download/vnc/)).
 Download and install the vnc client and then you would be able to connect to the container by specifying the address **127.0.0.1:5900**.
 The password to connect is **secret**

### Environment variables

There are some variables that can be configured on container start:

VAR        | DEFAULT                    | DESC
-----------|----------------------------|-----------------------------------------
P4_DOMAIN  | www.planet4.test           | The domain which is running P4 Wordpress
P4_PROTO   | https                      | Protocol to connect
P4_USER    | dev                        | Wordpress administration user
P4_PASS    | u3vsREsvjwo                | Wordpress administration user
EMAIL_USER | tester.greenwire@gmail.com |
EMAIL_PASS | u3vsREsvjwo                |

### Notes
If some tests fail, then the browser could remain open and intefere with running any additional test.
You can run **clean** to close all open browser windows.
    ```bash
      $ clean
    ```

## WARNING Windows Users

Note this repository has not yet been tested on windows platforms yet, any feedback will be welcome!
