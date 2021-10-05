class Scripting
  def self.remote_template_integration(cms_clientjs_editor_launcher_path, access_key)
    %Q(<script type="text/javascript" class="removeOnPublish" src="#{cms_clientjs_editor_launcher_path}"></script>
    <script type="text/javascript" class="removeOnPublish">
    jsHarmonyCmsEditor({"access_keys":["#{access_key}"]});
    </script>)
  end

  def self.editor_script(cms_server_url, cms_server_urls)
    if url_allowed?(cms_server_url, cms_server_urls)
      editor_script_unchecked(cms_server_url)
    else
      ''
    end
  end

  def self.editor_script_unchecked(cms_server_url)
    %Q(<script type="text/javascript" src="#{ERB::Util.html_escape(cms_server_url + 'js/jsHarmonyCMS.js')}"></script>)
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