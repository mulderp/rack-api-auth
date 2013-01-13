require "test/unit"
require "rack/test"
require "json"

$:.unshift('lib')
require 'rack-api-auth'

class AuthenticationTest < Test::Unit::TestCase
  include Rack::Test::Methods

  SomeUser = { :id => 32, :username => "patrick", :password => "dummy" }

  def app
    builder = Rack::Builder.new do
      use Rack::Session::Cookie, :secret => "test"
      use Rack::AuthMiddleware, :users => [SomeUser]

      run lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['All responses are OK']] }
    end
    builder
  end

  def test_create_session_success
    post "/auth/session", { :username => "patrick", :password => "dummy" }

    assert_equal last_response.status,  200

    user = JSON.parse(last_response.body)
    assert_equal 'patrick', user['username']
  end

  def test_create_session_failure
    post "/auth/session", { :username => "frank", :password => "dummy" }

    assert_equal 401, last_response.status
    response = JSON.parse(last_response.body)
    assert_equal response["error"], "Username or password is not valid"
  end

  def test_check_session_success
    # TODO: fixme
    post "/auth/session", { :username => "frank", :password => "dummy" }
    cookies = last_response.cookies # cookies needed , e.g. set_cookie ["value=10"]
    get "/auth/session"
    assert_equal 200, last_response.status
    assert_equal "{user: ...", last_response.body
  end

  def test_check_session_failure
    # TODO: fixme
    get "/auth/session"

    assert_equal last_response.status,  200
  end

  def test_delete_session_success
    # TODO: fixme
    delete "/auth/session"

    assert_equal last_response.status,  200
  end

  def test_delete_session_failure
    # TODO: fixme
    delete "/auth/session"

    assert_equal last_response.status,  200
  end

end
