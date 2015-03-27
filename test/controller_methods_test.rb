require 'test_helper'

class ControllerMethodsTestController < ActionController::Base
  include SimpleJsonApi::Rails::ControllerMethods

  def self.controller_path
    'test'
  end

  def simple_render
    render jsonapi: TEST_OBJECT, serializer: TEST_SERIALIZER
  end
end

describe ControllerMethodsTestController do
  let(:jsonapi_mime_type) { 'application/vnd.api+json' }
  let(:json_mime_type) { 'application/json' }

  before do
    Rails.application.routes.append do
      get 'simple_render' => 'test#simple_render'
    end
    Rails.application.routes_reloader.reload!
  end

  describe 'with no Accept header' do
    before do
      @request.headers.instance_exec { @env.delete('Accept') }
    end

    it 'returns Not Acceptable' do
      get :simple_render
      must_respond_with 406
    end
  end

  describe 'without JSON API mime type in Accept header' do
    before do
      @request.headers['Accept'] = json_mime_type
    end

    it 'returns Not Acceptable' do
      get :simple_render
      must_respond_with 406
    end
  end

  describe 'with JSON API mime type in Accept header' do
    before do
      @request.headers['Accept'] = jsonapi_mime_type
    end

    it 'returns OK' do
      get :simple_render
      must_respond_with 200
    end
  end
end
