require 'test_helper'

class CmsClientjsMiddlewareTest < ActiveSupport::TestCase
  def app
    ->(env) {
        req = Rack::Request.new(env)

        [200, env, req.path]
      }
  end

  def middleware
    CmsClientjsMiddleware.new(app, '/.jsHarmonyCMS/jsHarmonyCmsEditor.js')
  end

  def env_for(url, opts={})
    Rack::MockRequest.env_for(url, opts)
  end

  test "unknown url" do
    code, env, body = middleware.call env_for('http://localhost/some/path')

    assert_equal 200, code
    assert_equal "/some/path", body
  end

  test "js url" do
    code, env, body = middleware.call env_for('.jsHarmonyCMS/jsHarmonyCmsEditor.js')

    body = body&&body.join('')

    assert_equal 200, code
    assert_includes env, 'Content-Type'
    assert_match /jsHarmonyCmsEditor=/, body
  end
end