class Scripting
  def self.remote_template_integration(cms_clientjs_editor_launcher_path, access_key)
    %Q(<script type="text/javascript" class="removeOnPublish" src="#{cms_clientjs_editor_launcher_path}"></script>
    <script type="text/javascript" class="removeOnPublish">
    jsHarmonyCmsEditor({"access_keys":["#{access_key}"]});
    </script>)
  end

  def self.editor_script(cms_server_url)
    %Q(<script type="text/javascript" src="#{ERB::Util.html_escape(cms_server_url + 'js/jsHarmonyCMS.js')}"></script>)
  end
end