# TestCors2

This repository is an experiment in getting a Rails app to embed a form from a second Rails app and interact with the second Rails app through that form.

My vision is to have a webapps that contains a collection of items I'd like other webapps to be able to browse, add to, and select from.  Ideally, the webapp with the collection of items will be responsible for rendering the forms that allow people to browse, add, and select items, so that other webapps can easily bring up the form and interact with the collection server.


## Running

You'll need Docker and Apache.  Simply run:

```sh
docker-compose build ; docker-compose run site1 bundle install ; docker-compose up
```

Then install cors.conf into your Apache configuration and adjust the IP addresses of the websites to those of your docker host's IP.

