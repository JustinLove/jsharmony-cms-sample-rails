class RandomNumbersController < ApplicationController
  def index
    @page = load_cms_page
    @number = SecureRandom.hex(32)
  end
end
