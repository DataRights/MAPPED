[![Coverage Status](https://coveralls.io/repos/github/datarights/DataInSight/badge.svg?branch=develop)](https://coveralls.io/github/datarights/DataInSight?branch=develop)
[![Build status](https://travis-ci.org/datarights/DataInSight.svg?branch=develop)](https://travis-ci.org/datarights/DataInSight)

# MAPPED

MAPPED is a platform that helps citizens to send access requests to organizations. An access request is a request by a citizen to receive from an organization (information about) the personal data that that organization is processing in relation to him/her. The right to receive a swift, complete and understandable answer to such a request, called right of access, is guaranteed under European law in order to promote citizen empowerment.

This README documents steps that are necessary to set the development environment for application up and running.

# Using Docker for Development

1- Build and run app using docker-compose

`docker-compose -f docker-compose-development.yml build`

`docker-compose -f docker-compose-development.yml up`

2- For running tests you can go to docker bash

`docker exec -it mapped_app_1 bash`

And then run tests to make sure everything is ok:

`rails test`


# Deployment on Heroku

Deployments are done using Heroku, any push to master branch will trigger a deploy to Heroku.

# Deployment on servers using Docker

Define all the environment variables defined in docker-compose.yml and the run these commands:

`docker-compose build`

`docker-compose up -d`

# License

MAPPED is released under the GNU GENERAL PUBLIC LICENSE version 3.
