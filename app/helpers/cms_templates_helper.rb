module CmsTemplatesHelper
  def jsHarmonyCMS_include_tag
    javascript_include_tag "https://localhost:8081/js/jsHarmonyCMS.js", class: "removeOnPublish"
  end
end