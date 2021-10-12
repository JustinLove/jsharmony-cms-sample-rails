require 'test_helper'

class JsHarmonyCmsTest < ActiveSupport::TestCase
  def cms
    JsHarmonyCms.new({
      :content_path => 'test/fixtures/files',
      :cms_server_urls => ['*'],
    })
  end

  def env_for(url, opts={})
    Rack::MockRequest.env_for(url, opts)
  end

  def req_for(url, opts={})
    Rack::Request.new(env_for(url, opts))
  end

  def req_display
    req_for('//something')
  end

  def req_editor
    req_for("//something?jshcms_token=xxxx&jshcms_url=#{cms_server_url}")
  end

  def cms_server_url
    '//cms.server'
  end

  test "not in editor" do
    assert_equal false, cms.is_in_editor?(req_display)
  end

  test "in editor" do
    assert_equal true, cms.is_in_editor?(req_editor)
  end

  test "editor tag display mode" do
    assert_equal '', cms.get_editor_script(req_display)
  end

  test "editor tag editor mode" do
    script = cms.get_editor_script(req_editor)

    assert_match cms_server_url, script
  end

  test "server url security" do
    assert_equal '', JsHarmonyCms.new({:cms_server_urls => ['//elsewhere']}).get_editor_script(req_editor)
  end

  test "page: display, missing" do
    page = cms.get_page('/not/found', req_display)

    assert_equal '', page.editor_script
  end

  test "page: editor, missing" do
    page = cms.get_page('/not/found', req_editor)

    assert_not_equal '', page.editor_script
  end

  test "page: display, found" do
    page = cms.get_page('/test.html', req_display)

    assert_equal '', page.editor_script
    assert_equal 'Random Numbers - with CMS content', page.title
  end

  test "page: editor, found" do
    page = cms.get_page('/test.html', req_editor)

    assert_not_equal '', page.editor_script
    assert_equal '', page.title
  end
end