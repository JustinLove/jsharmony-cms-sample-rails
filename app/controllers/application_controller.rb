class ApplicationController < ActionController::Base
  def page
    @page ||= load_cms_page
  end
  helper_method :page

  def cms_is_in_editor?
    params.member? :jshcms_token
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
