require 'test_helper'

class ScriptingTest < ActiveSupport::TestCase
  test "remote template runs" do
    script = Scripting.remote_template_integration('launcher', 'token')
    assert_match /script/, script
    assert_match /launcher/, script
    assert_match /token/, script
  end

  test "editor script runs" do
    script = Scripting.editor_script('server')
    assert_match /script/, script
    assert_match /server/, script
  end
end