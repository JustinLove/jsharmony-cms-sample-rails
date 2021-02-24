class CmsComponentsController < ApplicationController
  layout false

  def index
    render action: params[:template]
  end
end
