# frozen_string_literal: true

require 'travel_time'
class TravelsController < ApplicationController
  def new
    @travel ||= Travel.new
    @time_default = DateTime.now + 40.minute
  end

  def index
    @travels = Travel.all
  end

  def destroy
    @travel = Travel.find(params[:id])
    if @travel.destroy
      flash[:success] = "Travel to #{@travel.destination_address} was successfully deleted."
      return redirect_to controller: 'travels', action: 'index'
    else
      flash[:error] = 'Something went wrong. Try again'
      return redirect_to controller: 'travels', action: 'index'
    end
  end

  def create
    arrival_datetime = get_arrival_time
    @travel = Travel.new(origin_address: params['origin_address'],
                         destination_address: params['destination_address'],
                         arrival_time: arrival_datetime,
                         meeting_duration: params['travel']['meeting_duration'].to_f)
    travel_time = TravelTime.get_travel_data(params['origin_address'], params['destination_address'], arrival_datetime)
    if travel_time
      @travel.update(travel_time: travel_time)
      if @travel.errors.any?
        error_messages = @travel.errors.full_messages.join(', ')
        flash[:danger] = "Errors: #{error_messages}"
      else
        flash[:success] = "It worked! Your travel time is #{travel_time} min"
        return redirect_to controller: 'travels', action: 'index'
      end
    else
      flash[:danger] = 'Something went wrong with the API call!'
    end
    redirect_to controller: 'travels', action: 'new'
  end

  private

  # def travel_params
  #   params.require(:travel).permit(:origin_address, :destination_address, :time_of_arrival)
  # end

  def get_arrival_time
    DateTime.new(
      params[:date][:year].to_i,
      params[:date][:month].to_i,
      params[:date][:day].to_i,
      params[:date][:hour].to_i,
      params[:date][:minute].to_i
    )
  end
end
