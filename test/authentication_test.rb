require "test/unit"
require "rack/test"
require 'cuba'
require "json"

$:.unshift('lib')
require 'rack-api-auth'

class API < Cuba; end
API.define do
   on "hello" do
     res.write "Hello world!"
   end
end

class AuthenticationTest < Test::Unit::TestCase
  include Rack::Test::Methods

  Tokens = [{ :id => 32, :username => "patrick", :token => "79d4d9ee34e3f589ee94d080357afd8e" }]

  def app
    builder = Rack::Builder.new do
      use Rack::AuthMiddleware, :users => Tokens
      use API

      run lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['All responses are OK']] }
    end
    builder
  end

  def test_access_success
    get "/api/confidential", 'Authorization: Token token="79d4d9ee34e3f589ee94d080357afd8e"', "CONTENT_TYPE" => "application/json"

    assert_equal last_response.status,  200

    user = JSON.parse(last_response.body)
    assert_equal 'patrick', user['username']
  end

  def test_access_fails
    get "/api/confidential", 'Authorization: Token token=""', "CONTENT_TYPE" => "application/json"

    assert_equal last_response.status,  200

    user = JSON.parse(last_response.body)
    assert_equal 'patrick', user['username']
  end


end
