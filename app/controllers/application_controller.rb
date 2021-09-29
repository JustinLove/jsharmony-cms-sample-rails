class ApplicationController < ActionController::Base
  def page
    @page ||= load_cms_page
  end
  helper_method :page

  def load_cms_page
    path = "public/cms/content/#{params[:controller]}/#{params[:action]}.html"
    CmsPage.new(JSON.parse(File.read(path)))
  rescue
    CmsPage.new({})
  end
end
