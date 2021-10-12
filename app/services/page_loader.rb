class PageLoader
  attr_reader :content_path
  attr_reader :url_resolution

  def initialize(_content_path, _url_resolution = UrlResolution.default_document('index.html'))
    @content_path = _content_path
    @url_resolution = _url_resolution
  end

  def call(url)
    resolve(url).each do |path|
      if should_try_to_load?(path)
        return CmsPage.new(load_file(path))
      end
    end

    return CmsPage.new({})
  end

  def resolve(url)
    self.class.resolve(content_path, url, url_resolution)
  end

  def should_try_to_load?(path)
    File.file?(path) && File.readable?(path)
  rescue SystemCallError
    false
  end

  def load_file(path)
    JSON.parse(File.read(path)) || {}
  end

  def self.resolve(content_path, url, url_resolution = UrlResolution.default_document('index.html'))
    uri = URI(url)
    path = Rack::Utils.unescape_path(uri.path)
    trailing_slash = uri.path.end_with?('/') # removed by clean_path_info
    path = Rack::Utils.clean_path_info(path)
    path = File.join(content_path, path)
    url_resolution.call(path, trailing_slash)
  end
end