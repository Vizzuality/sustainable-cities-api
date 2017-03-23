# Sustainable Cities API #

[![Build Status](https://travis-ci.org/Vizzuality/sustainable_cities.svg?branch=develop)](https://travis-ci.org/Vizzuality/sustainable_cities) [![Code Climate](https://codeclimate.com/github/Vizzuality/sustainable_cities/badges/gpa.svg)](https://codeclimate.com/github/Vizzuality/sustainable_cities)

## USAGE ##

  Start by checking out the project from github

```
git clone https://github.com/Vizzuality/sustainable_cities.git
cd sustainable_cities
```

  You can either run the application natively, or inside a docker container.

## NATIVELY ##

### REQUIREMENTS ###

  - **Ruby version:** 2.4.0
  - **PostgreSQL 9.4+** [How to install](http://exponential.io/blog/2015/02/21/install-postgresql-on-mac-os-x-via-brew/)

**Just execute the script file in `bin/setup`**

  Depends on Sustainable Cities [repository](https://github.com/Vizzuality/sustainable_cities)

**or install the dependencies manually:**

### Install global dependencies: ###

    gem install bundler

### Install gems: ###

    bundle install

### Set up the database ###

    cp config/database.yml.sample config/database.yml
    cp env.sample .env

    bundle exec rake db:create
    bundle exec rake db:migrate

### Load sample data: ###

    bundle exec rake db:seed

### Run application: ###

    bin/rails s

## USING DOCKER ##

### REQUIREMENTS FOR DOCKER ###

  If You are going to use containers, You will need:

- [Docker](https://www.docker.com/)
- [docker-compose](https://docs.docker.com/compose/)

### EXECUTING ###

  To setup the project on docker:

```
./service develop
```

  To run the tests on docker:

```
./service test
```

## TEST ##

  To run the tests on docker:

```
./service test
```

  Run rspec:

```ruby
  bin/rspec
```

## DEPLOYMENT ##

## CONTRIBUTING ##

### BEFORE CREATING A PULL REQUEST ###

Please check all of [these points](https://github.com/Vizzuality/sustainable_cities/blob/master/CONTRIBUTING.md).

1. Fork it!
2. Create your feature branch: `git checkout -b feature/my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin feature/my-new-feature`
5. Submit a pull request :D
