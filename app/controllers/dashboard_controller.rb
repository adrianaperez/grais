class DashboardController < ApplicationController
  
	layout "dashboard"

  def index
    @course = Course.new
  end
end
