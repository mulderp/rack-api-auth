require "test/unit"
require "rack/test"
require 'cuba'
require "json"

$:.unshift('lib')
require 'rack-api-auth'

require_relative "app/api"

class AuthenticationTest < Test::Unit::TestCase
  include Rack::Test::Methods

  Tokens = [{ :id => 42, :token => "79d4d9ee34e3f589ee94d080357afd8e" }]

  def app
    builder = Rack::Builder.new do
      use Rack::AuthMiddleware, :tokens => Tokens

      run API
    end
    builder
  end

  def test_access_success
    header 'Authorization', "79d4d9ee34e3f589ee94d080357afd8e"

    get "/api/confidential" 

    assert_equal last_response.status, 200
    assert_equal "Greetings from inside", last_response.body
  end

  def test_access_fails
    get "/api/confidential", 'Authorization: Token token=""', "CONTENT_TYPE" => "application/json"

    assert_equal last_response.status, 400
  end


end
