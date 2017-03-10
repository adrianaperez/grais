class DashboardController < ApplicationController
  
	layout "base"

  def index
    @course = Course.new
  end
end
