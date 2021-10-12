class ApplicationController < ActionController::Base

  def cms
    @cms ||= JsHarmonyCms.new(Rails.configuration.x.jsHarmonyCMS)
  end

  def page
    @page ||= cms.get_page("/content/#{params[:controller]}/#{params[:action]}.html", request)
  end
  helper_method :page

  def cms_is_in_editor?
    cms.is_in_editor?(request)
  end
  helper_method :cms_is_in_editor?
end
