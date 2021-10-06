class ApplicationController < ActionController::Base

  def cms
    @cms ||= JsHarmonyCms.new(Rails.configuration.x.jsHarmonyCMS)
  end

  def page
    @page ||= load_cms_page
  end
  helper_method :page

  def cms_is_in_editor?
    cms.is_in_editor?(request)
  end
  helper_method :cms_is_in_editor?

  def load_cms_page
    if cms_is_in_editor?
      CmsPage.new({})
    else
      path = "public/cms/content/#{params[:controller]}/#{params[:action]}.html"
      CmsPage.new(JSON.parse(File.read(path)))
    end
  rescue
    CmsPage.new({})
  end
end
