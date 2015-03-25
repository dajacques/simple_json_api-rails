class AnimalsController < ApplicationController
  def index
    @animals = Animal.all
    render jsonapi: @animals, serializer: AnimalSerializer
  end

  def show
    @animal = Animal.find(params[:id])
    render jsonapi: @animal, serializer: AnimalSerializer
  end
end
