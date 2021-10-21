require 'js_harmony_cms/scripting'

module CmsTemplatesHelper
  def jsHarmonyCMS_integration_tag
    JsHarmonyCms::Scripting.remote_template_integration(Rails.configuration.x.jsHarmonyCMS.cms_clientjs_editor_launcher_path, Rails.configuration.x.jsHarmonyCMS.access_key).html_safe
  end
end