class RandomNumbersController < ApplicationController
  def index
    @number = SecureRandom.hex(32)
  end
end
