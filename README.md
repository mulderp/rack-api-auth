# Rack::Api::Auth

Provide basic paths for API authentication as Rack middleware by adding POST/GET/DELETE session routes with very simple authentication mechanics

## Installation

Add this line to your application's Gemfile:

    gem 'rack-api-auth'

In a Rails application:

    config.middleware.use Rack::Session::Cookie, :key => 'rack.session', :expire_after => 2592000, :secret => 'somesecretsessionidentifier'
    config.middleware.use Rack::AuthMiddleware, :users => [{:username => "patrick", :password => "letmein", :id => 32}]

## Usage

The middleware adds a very quick, basic authentication check to your application by adding these routes:

* POST /auth/session --> create authenticated session (see Curl script in script/new_session.sh)
* GET /auth/session --> check authenticated session (see Curl script in script/check_session.sh)
* DELETE /auth/session --> logout

## Contributing

Thanks for sharing ideas and feedback!.
Feedback in form of comments/issues/pull requests is very welcome!

## Todos
* basic cleanup HTTP status codes, JSON parsing
* Use DB store for authentication lookup rather than Hash
* Add simple demo application for Rack/Sinatra/Rails
* Look into other session stores (Redis, DB, ...)
* More testing / better testing setup

## Some useful references
* http://rack.rubyforge.org/doc/Rack
* https://github.com/hassox/warden
* https://github.com/cyu/rack-cors

## License
(c) 2013, patrick mulder {mailto: mulder.patrick@gmail.com}, MIT license

