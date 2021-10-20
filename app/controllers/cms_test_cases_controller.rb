class CmsTestCasesController < ApplicationController
  def page
    @page ||= cms.get_page("/content/#{params[:action]}/index.html", request)
  end
  helper_method :page

  def login
  end

  def standalone_onecolumn
  end

  def standalone_twocolumn
  end
end
