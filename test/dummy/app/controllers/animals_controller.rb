require 'simple_json_api/rails/controller_methods'

class AnimalsController < ApplicationController
  include SimpleJsonApi::Rails::ControllerMethods

  def index
    @animals = Animal.all
    render jsonapi: @animals, serializer: AnimalSerializer
  end

  def show
    # @animal = Animal.find(params[:id])
    @animal = Animal.find_by(Animal.primary_key.to_sym => params[:id])
    render jsonapi_error: not_found_error and return unless @animal
    render jsonapi: @animal, serializer: AnimalSerializer
  end

  private

  def not_found_error
    SimpleJsonApi::Rails::NotFoundError.new(
      "Couldn't find Animal with '#{Animal.primary_key}'=#{params[:id]}"
    )
  end
end
