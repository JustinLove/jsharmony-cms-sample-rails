module CmsTemplatesHelper
  def jsHarmonyCMS_include_tag
    javascript_include_tag "/jsHarmonyCmsClient.min.js", class: "removeOnPublish"
  end

  def jsHarmonyCMS_start_tag
    content_tag :script, "jsHarmonyCmsClient({'access_keys':['#{Rails.configuration.x.jsHarmonyCMS.access_key}']});".html_safe, class: "removeOnPublish"
  end

  def jsHarmonyCMS_editor_tag
    jsHarmonyCMS_include_tag + "\n" + jsHarmonyCMS_start_tag
  end

  def jsHarmonyCMS_is_in_editor?
    params.member? :jshcms_token
  end
end