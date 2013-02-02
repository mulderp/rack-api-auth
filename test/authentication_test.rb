require "test/unit"
require "rack/test"
require 'cuba'
require "json"

$:.unshift('lib')
require 'rack-api-auth'

class API < Cuba; end
API.define do
   on "/api/confidential" do
     res.write "Greetings from inside"
   end

   on "/api/pulbic" do
     res.write "Greetings from outside"
   end
end

class AuthenticationTest < Test::Unit::TestCase
  include Rack::Test::Methods

  Tokens = [{ :id => 32, :username => "patrick", :token => "79d4d9ee34e3f589ee94d080357afd8e" }]

  def app
    builder = Rack::Builder.new do
      use Rack::AuthMiddleware, :users => Tokens

      run API
    end
    builder
  end

  def test_access_success
    get "/api/confidential", 'Authorization: Token token="79d4d9ee34e3f589ee94d080357afd8e"', "CONTENT_TYPE" => "application/json"

    assert_equal last_response.status, 200
  end

  def test_access_fails
    get "/api/confidential", 'Authorization: Token token=""', "CONTENT_TYPE" => "application/json"

    assert_equal last_response.status, 400
  end


end
