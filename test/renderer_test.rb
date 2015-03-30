require 'test_helper'

class RendererTestController < ActionController::Base
  def self.controller_path
    'test'
  end

  def render_without_serializer
    render jsonapi: test_object
  end

  def render_with_respond_to
    respond_to do |format|
      format.jsonapi { render jsonapi: test_object, serializer: test_serializer }
    end
  end
end

describe RendererTestController do
  before do
    Rails.application.routes.append do
      get 'render_without_serializer' => 'test#render_without_serializer'
      get 'render_with_respond_to' => 'test#render_with_respond_to'
    end
    Rails.application.routes_reloader.reload!
  end

  it 'errors without a serializer' do
    -> { get :render_without_serializer }.must_raise ArgumentError
  end

  it 'renders with respond_to' do
    get :render_with_respond_to, format: :jsonapi
    must_respond_with 200
  end
end
