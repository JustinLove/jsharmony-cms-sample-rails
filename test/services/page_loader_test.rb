require 'test_helper'

class PageLoaderTest < ActiveSupport::TestCase
  def loader_class
    PageLoader
  end

  def loader
    loader_class.new('test/fixtures/files')
  end

  test "missing" do
    page = loader.call('/not/found')

    assert_equal '', page.editor_script
  end

  test "found" do
    page = loader.call('/test.html')

    assert_equal '', page.editor_script
    assert_equal 'Random Numbers - with CMS content', page.title
  end

  test "path resolution, plain" do
    paths = loader_class.resolve('dir', '/path/file.html')

    assert_equal ['dir/path/file.html'], paths
  end

  test "path resolution, make absolute" do
    paths = loader_class.resolve('dir', 'path/file.html')

    assert_equal ['dir/path/file.html'], paths
  end

  test "path resolution, fully qualified" do
    paths = loader_class.resolve('dir', 'http://host/path/file.html')

    assert_equal ['dir/path/file.html'], paths
  end

  test "path resolution, trailing slash" do
    paths = loader_class.resolve('dir', '/path/')

    assert_equal ['dir/path/index.html'], paths
  end

  test "path resolution, plain path" do
    paths = loader_class.resolve('dir', '/path')

    assert_equal ['dir/path', 'dir/path/index.html'], paths
  end

  test "path resolution, different extension" do
    paths = loader_class.resolve('dir', '/path/file.ext')

    assert_equal ['dir/path/file.ext', 'dir/path/file.ext/index.html'], paths
  end

  test "path resolution, path traversal attack 1" do
    paths = loader_class.resolve('dir', '/../../path/file.html')

    assert_equal ['dir/path/file.html'], paths
  end

  test "path resolution, path traversal attack 2" do
    paths = loader_class.resolve('dir', 'path/../../file.html')

    assert_equal ['dir/file.html'], paths
  end

  [
    '%2e%2e%2f', # represents ../
    '%2e%2e/', # represents ../
    '..%2f', # represents ../ 
    '%2e%2e%5c', # represents ..\
    '%2e%2e\\', # represents ..\
    '..%5c', # represents ..\
    '%252e%252e%255c', # represents ..\
    '..%255c', # represents ..\
    '..%c0%af', #represents ../ 
    '..%c1%9c', # represents ..\ 
  ].each do |fragment|
    test "path resolution, path traversal attack encoding #{fragment}" do
      begin
        paths = loader_class.resolve('dir', "#{fragment}path/file.html")

        paths.each do |path|
          assert_match /^dir\//, path
          refute_match /\.\.[\/\\]/, path
        end
      rescue
        pass
      end
    end
  end
end