require 'test_helper'

class CmsRouterMiddlewareTest < ActiveSupport::TestCase
  def app
    ->(env) {
        req = Rack::Request.new(env)

        [200, env, req.path]
      }
  end

  def middleware
    CmsRouterMiddleware.new(app, 'test/fixtures/files/jshcms_redirects.json')
  end

  def env_for(url, opts={})
    Rack::MockRequest.env_for(url, opts)
  end

  test "unknown url" do
    code, env, body = middleware.call env_for('http://localhost/some/path')

    assert_equal 200, code
    assert_equal "/some/path", body
  end

  test "301 redirect" do
    code, env, body = middleware.call env_for('http://localhost/301')

    assert_equal 301, code
    assert_equal '/random_numbers', env['Location']
  end

  test "302 redirect" do
    code, env, body = middleware.call env_for('http://localhost/302')

    assert_equal 302, code
    assert_equal '/random_numbers', env['Location']
  end

  test "passthru" do
    code, env, body = middleware.call env_for('http://localhost/proxy')

    assert_equal 200, code
    assert_equal "/random_numbers", body
  end

  test "begins" do
    code, env, body = middleware.call env_for('http://localhost/beginswith')

    assert_equal 302, code
    assert_equal '/begins/with', env['Location']
  end

  test "begins case insensitive" do
    code, env, body = middleware.call env_for('http://localhost/Beginswith')

    assert_equal 302, code
    assert_equal '/begins/with/case', env['Location']
  end

  test "exact" do
    code, env, body = middleware.call env_for('http://localhost/exact')

    assert_equal 302, code
    assert_equal '/exact/match', env['Location']
  end

  test "exact case insensitive" do
    code, env, body = middleware.call env_for('http://localhost/exact/CASE')

    assert_equal 302, code
    assert_equal '/exact/match/case', env['Location']
  end

  test "regex" do
    code, env, body = middleware.call env_for('http://localhost/regex/1')

    assert_equal 302, code
    assert_equal '/regex/to/1', env['Location']
  end

  test "regex case insensitive" do
    code, env, body = middleware.call env_for('http://localhost/Regex/1')

    assert_equal 302, code
    assert_equal '/regex/case/to/1', env['Location']
  end
end