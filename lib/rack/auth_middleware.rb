require 'json'

module Rack
  class AuthMiddleware

    SESSION_PATH = '/auth/session'

    def initialize(app, authenticated_users)
      @app = app
      @authenticated_users = authenticated_users[:users]
    end
  
    def call(env)
      env['rack.auth'] = Authenticator.new(env, @authenticated_users)
      @authenticator = env['rack.auth']

      if env['PATH_INFO'] == SESSION_PATH 
        puts "--> Rack::Auth::Middleware: #{@authenticator.request.request_method} #{SESSION_PATH}"
        status, headers, body = route_request
      else
        puts "--> enter @app.call for #{env['PATH_INFO']}"
        status, headers, body = @app.call(env) 
      end

      response ||= Rack::Response.new body, status, headers
      puts "--> finish response: #{response.to_a}"
      response.finish
    end

    def route_request
      if @authenticator.request.get?
        status, headers, body = @authenticator.authenticated?
      elsif @authenticator.request.post?
        status, headers, body = @authenticator.authenticate!
      elsif @authenticator.request.delete?
        status, headers, body = @authenticator.clear!
      end
      [ status, headers, body ]
    end

    class Authenticator

      def initialize(env, authenticated_users)
        @env = env
        @authenticated_users = authenticated_users
      end

      def authenticate!
        auth_user = lookup_user
        if auth_user[:username] 
          user_values = auth_user.slice(:id, :username)
          Authenticator.store_user(session, user_values.merge({:auth => :true, _csrf: "abcde"}))
          [ 200, {}, user_values.merge(:auth => true).to_json ] 
        else
          [ 401, {}, { :error => "Username or password is not valid"}.to_json ] 
        end
      end

      def lookup_user
        @authenticated_users.each do |user|
          if user[:username] == params["username"]
            return user
          end
        end
        {}
      end

      def authenticated?
        auth = begin
                 if user_session
                   user_session[:auth]
                 else
                   false
                 end
               end
        if auth
          status = 200
          body = session['user']
        else
          status = 401
          body = "No valid session"
        end
        [ status, {}, body.to_json ]
      end

      def clear!
        user_session = session['user'].inspect
        status = 200
        headers =  { 'Set-Cookie' => 'rack.session=' }
        body = { :auth => false }
        session.clear
        [ status, headers, body.to_json ]
      end

      def self.store_user(session, h)
        session['user'] = h # to check: more options in header with "Set-Cookie" => "abcde=1111" 
      end

      def session
         @session = begin
                      if @env['rack.session']
                        @env['rack.session']
                      else
                        raise "No session found"
                      end
                    end
      end

      def user_session
        user_session = session['user']
      end


      def request
        @request ||= Rack::Request.new(@env)
      end

      def params
        request.params
      end

    end
  end
end
