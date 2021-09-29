module CmsTemplatesHelper
  def jsHarmonyCMS_editor_tag
    %Q(<script type="text/javascript" class="removeOnPublish" src="/.jsHarmonyCMS/jsHarmonyCmsEditor.js"></script>
    <script type="text/javascript" class="removeOnPublish">
    jsHarmonyCmsEditor({"access_keys":["#{Rails.configuration.x.jsHarmonyCMS.access_key}"]});
    </script>).html_safe
  end
end