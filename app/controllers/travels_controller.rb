require 'travel_time'
class TravelsController < ApplicationController
  before_create :travel_params
  def new
    @travel ||= Travel.new
  end

  def create
    @travel= Travel.new(travel_params)
    travel_time = TravelTime.get_travel_data(travel_params)
    if travel_time
      @travel.update(travel_time: travel_time)
      @travel.save
      if @travel.errors.any?
        flash[:danger] = "Something went wrong!"
      else
        flash[:success] = "It worked! Your travel time is #{travel_time} min"
        return redirect_to :controller => 'travels', :action => 'index'#need to create index + controller_spec
      end
    else
      flash[:danger] = "Something went wrong with the API call!"
    end
    return redirect_to :controller => 'travels', :action => 'new'
  end

  private
    def travel_params
      params.require(:travel).permit(:origin_address, :destination_address, :time_of_arrival)
    end
  
  
end
