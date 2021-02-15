class CmsTemplatesController < ApplicationController
  def index
    render action: params[:template]
  end
end
