# TestCors2

This repository is an experiment in getting a Rails app to embed a form from a second Rails app and interact with the second Rails app through that form.

My vision is to have a webapps that contains a collection of items I'd like other webapps to be able to browse, add to, and select from.  Ideally, the webapp with the collection of items will be responsible for rendering the forms that allow people to browse, add, and select items, so that other webapps can easily bring up the form and interact with the collection server.


## Running

You'll need Docker and Apache.  Simply run:

```sh
docker-compose build ; docker-compose run site1 bundle install ; docker-compose up
```

Then install cors.conf into your Apache configuration and adjust the IP addresses of the websites to those of your docker host's IP.

## Hackery

In order to get this all to work, I had to:

1. Set self.forgery_protection_origin_check = false in SubmissionController to avoid it failing the same-origin check when validating the authenticity of a POST from a form
2. Patch the normalize_action_path method because the initial AJAX GET request for the form included the http://site2.blahblah.com portion of the URL in the action_path call, but the AJAX POST request from the form did not include the URL.  This meant that when comparing the authenticity tokens, the tokens appeared different because the action_path was different
3. Patch JQuery so that it doesn't disable the ability to execute JavaScript returned by a remote server.  Looks like Rails sets crossDomain to true for any request that includes http:// in it.  When JQuery sees crossDomain as true, it disables the "script" handler for responses, meaning JavaScript won't be executed if the response returns JavaScript.
