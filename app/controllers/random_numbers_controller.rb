class RandomNumbersController < ApplicationController
  attr_reader :page
  helper_method :page

  def index
    @page = cms.get_page("/random_numbers/index.html", request)
    @number = SecureRandom.hex(32)
  end
end
