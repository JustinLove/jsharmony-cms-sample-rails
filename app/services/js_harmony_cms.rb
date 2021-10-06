class JsHarmonyCms
  attr_reader :config

  DefaultConfig = {
    :cms_clientjs_editor_launcher_path => '/.jsHarmonyCms/jsHarmonyCmsEditor.js',
    :cms_server_urls => [],
  }

  def initialize(config = {})
    @config = DefaultConfig.merge config
  end

  def cms_clientjs_editor_launcher_path
    config[:cms_clientjs_editor_launcher_path]
  end

  def cms_server_urls
    config[:cms_server_urls]
  end

  def is_in_editor?(req)
    params = (req && req.params) || {}
    !!params['jshcms_token']
  end

  def get_editor_script(req)
    params = (req && req.params) || {}
    cms_server_url = params['jshcms_url']

    if is_in_editor?(req) && url_allowed?(cms_server_url)
      Scripting.editor_script(cms_server_url)
    else
      ''
    end
  end

  def url_allowed?(cms_server_url)
    self.class.url_allowed?(cms_server_url, cms_server_urls)
  end

  def self.url_allowed?(cms_server_url, cms_server_urls)
    cur_uri = URI(cms_server_url)
    return false unless cur_uri
    cms_server_urls.map do |rule_url|
      next unless rule_url && rule_url != ''
      return true if rule_url == '*'
      rule_uri = URI(rule_url)
      next unless rule_uri
      if rule_uri.scheme
        next unless same_string?(cur_uri.scheme, rule_uri.scheme)
      end
      next unless same_string?(cur_uri.host, rule_uri.host)
      next unless same_string?(cur_uri.port, rule_uri.port)
      return true if same_path?(cur_uri, rule_uri)
    end
    return false
  end

  private

  def self.same_string?(a, b)
    a.to_s.casecmp?(b.to_s)
  end

  def self.same_path?(a, b)
    pathA = a.path.empty? ? '/' : a.path
    pathB = b.path.empty? ? '/' : b.path
    pathA.starts_with?(pathB)
  end
end