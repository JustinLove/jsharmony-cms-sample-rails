class ApplicationController < ActionController::Base
  def load_cms_page
    path = "public/cms/content/#{params[:controller]}/#{params[:action]}.html"
    CmsPage.new(JSON.parse(File.read(path)))
  rescue
    CmsPage.new({})
  end
end
