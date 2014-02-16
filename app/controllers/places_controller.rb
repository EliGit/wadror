class PlacesController < ApplicationController
  def index
  end

  def search
    if(params[:city].empty?)
      redirect_to places_path, notice: "Empty input!"
    else
      @places = BeermappingApi.places_in(params[:city])
      session[:last_place] = params[:city].downcase

      if @places.empty?
        redirect_to places_path, notice: "No locations in #{params[:city]}"
      else
        render :index
      end
    end
  end

  def show
    city = session[:last_place]

    Rails.cache.read(city).each do |place|
      if place.id == params[:id]
        @place = place
      end
    end
    #render :show
  end

end