class Admin::Con::DashboardController < ApplicationController

  layout "conferences"

  def index
    @conferences = Conference.find(:all, :order => 'start_date')
    if @conferences
      if params[:id]
        @current_conference = Conference.find(params[:id])
      else
        index = 0
        @current_conference = @conferences[0]
        while index < @conferences.size and @current_conference.in_the_past?
          index += 1
          @current_conference = @conferences[index]
        end
      end
    else
      @conferences = Array.new
    end
  end

  def help
    @conferences = Conference.find(:all, :order => 'start_date')
    if params[:id]
      @current_conference = Conference.find(params[:id])
    end
  end

end
