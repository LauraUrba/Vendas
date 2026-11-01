class CarsController < ApplicationController
  def show
    @car = current_car
    @line_items = @car.line_items.includes(:produto)
  end
end
