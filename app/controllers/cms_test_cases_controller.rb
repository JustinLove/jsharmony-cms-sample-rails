class CmsTestCasesController < ApplicationController
  def page
    @page ||= cms.get_page("/#{params[:action]}/index.html", params)
  end
  helper_method :page

  def login
  end

  def standalone_onecolumn
  end

  def standalone_twocolumn
  end
end
