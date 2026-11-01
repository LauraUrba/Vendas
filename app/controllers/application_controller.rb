class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  private def current_car
    @current_car ||= Car.find_by(id: session[:car_id]) || 
      Car.create.tap { |c| session[:car_id] = c.id }
  end
  helper_method :current_car

end
