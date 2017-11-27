# Greenpeace Planet4 docker development environment

![Planet4](https://cdn-images-1.medium.com/letterbox/300/36/50/50/1*XcutrEHk0HYv-spjnOej2w.png?source=logoAvatar-ec5f4e3b2e43---fded7925f62)

## What is Planet4?

Planet4 is the NEW Greenpeace web platform

## What is this repository?

This repository contains a docker image to set up a docker container that contains [planet4-selenium-tests](https://github.com/greenpeace/planet4-selenium-tests) and the needed tools to run these tests.
The image is based on [selenium/standalone-chrome-debug](https://github.com/SeleniumHQ/docker-selenium)

## How to set up the docker environment

### Requirements

Requirements for running this testing environment:

  * [install docker](https://docs.docker.com/engine/installation/)

### Running planet4 selenium tests in docker container


1. Clone this repo
    ```bash
      $ git clone https://github.com/greenpeace/planet4-docker-selenium-tests
      $ cd planet4-docker-selenium-tests
    ```
1. Copy the file variables.env.example to variables.env
    ```bash
      $ cp variables.env.example variables.env
    ```
1. In variables.env change the variables to match the site you want to test.
1. Build the image and run the container.
    ```bash
      $ cd planet4-docker-compose
      $ docker build -t planet4-selenium-tests .
      $ docker run --rm --name planet4-tests -p 5900:5900   --env-file variables.env  planet4-selenium-tests
    ```
1. Connect to container.
    ```bash
      $ docker container exec -it planet4-tests bash       
    ```
1. Inside the container your can run the phpunit tests.
    ```bash
      $ ./run_all_sample.sh # to run all tests
      $ vendor/bin/phpunit -c tests  # to run all tests   
      $ vendor/bin/phpunit tests/p4/Articles.php   # to run a single test
    ```
1. (Optional) If you need to see the actual browser running the tests, you will need a vnc client. 
 A choice would be ([RealVnc](https://www.realvnc.com/en/connect/download/vnc/)).
 Download and install the vnc client and then you would be able to connect to the container by specifying the address **127.0.0.1:5900** 


### Environment variables

There are some variables that should be set for local setup in variables.env file:

_Url of planet4 site_
  * PLANET4_URL=test.planet4.dev
    
_Admin user_
  * PLANET4_USER=dev
    
_Admin password_
  * PLANET4_USER_PASS=


### Notes
If some tests fail, then the browser could remain open and intefere with running any additional test.
You can run **clean** to close all open browser windows.
    ```bash
      $ clean
    ```    

## WARNING Windows Users

Note this repository has not yet been tested on windows platforms yet, any feedback will be welcome!
