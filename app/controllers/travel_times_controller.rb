require 'travel_time'
class TravelTimesController < ApplicationController
  def index
    
  end

  def create
    travel_time = TravelTime.get_travel_data(params[:origin_address], params[:destination_address])
    if travel_time
      flash[:success] = "It works! Your travel time is #{travel_time}"
    else
      flash[:warning] = "Something went wrong!"
    end
    return redirect_to :controller => 'travel_times', :action => 'index'
  end
  
  
end
