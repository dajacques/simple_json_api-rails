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

  def render_from_exception
    render jsonapi_error: SimpleJsonApi::Rails::Error.new('jsonapi_error renderer test')
  end

  def render_from_string
    render jsonapi_error: 'jsonapi_error renderer test'
  end
end

describe RendererTestController do
  before do
    Rails.application.routes.append do
      get 'render_without_serializer' => 'test#render_without_serializer'
      get 'render_with_respond_to' => 'test#render_with_respond_to'
      get 'render_from_exception' => 'test#render_from_exception'
      get 'render_from_string' => 'test#render_from_string'
    end
    Rails.application.routes_reloader.reload!
  end

  describe 'jsonapi renderer' do
    it 'errors without a serializer' do
      -> { get :render_without_serializer }.must_raise ArgumentError
    end

    it 'renders with respond_to' do
      get :render_with_respond_to, format: :jsonapi
      must_respond_with 200
    end
  end

  describe 'jsonapi_error renderer' do
    let(:errors) do
      {
        errors: [
          {
            status: '500',
            detail: 'jsonapi_error renderer test'
          }
        ]
      }
    end

    it 'renders an error response from a SimpleJsonApi::Rails exception' do
      get :render_from_exception, format: :jsonapi
      must_respond_with 500
      response.body.must_equal errors.to_json
    end

    it 'renders an error response from a string' do
      get :render_from_string, format: :jsonapi
      must_respond_with 500
      response.body.must_equal errors.to_json
    end
  end
end
