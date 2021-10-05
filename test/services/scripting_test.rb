require 'test_helper'

class ScriptingTest < ActiveSupport::TestCase
  test "remote template runs" do
    script = Scripting.remote_template_integration('launcher', 'token')
    assert_match /script/, script
    assert_match /launcher/, script
    assert_match /token/, script
  end

  test "editor script runs" do
    script = Scripting.editor_script_unchecked('server')
    assert_match /script/, script
    assert_match /server/, script
  end

  test "server url verification: none allowed" do
    assert_equal false, Scripting.url_allowed?('//something', [])
  end

  test "server url verification: all allowed" do
    assert_equal true, Scripting.url_allowed?('//something', ['*'])
  end

  test "server url verification: same path" do
    assert_equal true, Scripting.url_allowed?('//something/some/path', ['//something/some/path'])
  end

  test "server url verification: different path" do
    assert_equal false, Scripting.url_allowed?('//something/some/thing', ['//something/some/path'])
  end

  test "server url verification: root path" do
    assert_equal true, Scripting.url_allowed?('//something', ['//something/'])
  end

  test "server url verification: prefix path" do
    assert_equal true, Scripting.url_allowed?('//something/some/path/and/more', ['//something/some/path'])
  end

  test "server url verification: same scheme" do
    assert_equal true, Scripting.url_allowed?('http://something', ['http://something'])
  end

  test "server url verification: different scheme" do
    assert_equal false, Scripting.url_allowed?('http://something', ['https://something'])
  end

  test "server url verification: same host" do
    assert_equal true, Scripting.url_allowed?('http://something', ['http://something'])
  end

  test "server url verification: different host" do
    assert_equal false, Scripting.url_allowed?('http://hacker', ['http://something'])
  end

  test "server url verification: same port" do
    assert_equal true, Scripting.url_allowed?('http://something:80', ['http://something:80'])
  end

  test "server url verification: different port" do
    assert_equal false, Scripting.url_allowed?('http://something:80', ['http://something:8081'])
  end

  test "server url verification: same default port" do
    assert_equal true, Scripting.url_allowed?('http://something', ['http://something:80'])
  end

  test "server url verification: different default port" do
    assert_equal false, Scripting.url_allowed?('http://something', ['http://something:8081'])
  end

  test "server url verification: multiple entries" do
    assert_equal true, Scripting.url_allowed?('//something/some/thing', ['//something/some/path', '*'])
  end
end