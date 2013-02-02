require 'json'

module Rack
  class AuthMiddleware

    def initialize(app, options)
      @app = app
      @tokens = options[:tokens]
    end
  
    def call(env)
      env['rack.auth'] = Authenticator.new(env, @tokens)
      @authenticator = env['rack.auth'] # add Rack object

      status, headers, body = @app.call(env) 

      response ||= Rack::Response.new body, status, headers
      puts "--> finish response: #{response.to_a}"
      response.finish
    end

    class Authenticator

      def initialize(env, valid_tokens)
        @env = env
        @header_token = env['HTTP_AUTHORIZATION']
        @valid_tokens = valid_tokens
        @found_token = {}
      end

      def authenticate!
        @valid_tokens.each do |token|
            puts token.inspect
          if token[:token] == @header_token
            @found_token = token
            return true
          end
        end
        false
      end

    end
  end
end
