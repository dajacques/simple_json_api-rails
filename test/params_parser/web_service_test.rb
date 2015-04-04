require 'params_parser/helper'

class WebServiceTest < ActionDispatch::IntegrationTest
  class TestController < ActionController::Base
    def assign_parameters
      if params[:full]
        render :text => dump_params_keys
      else
        render :text => (params.keys - ['controller', 'action']).sort.join(", ")
      end
    end

    def dump_params_keys(hash = params)
      hash.keys.sort.inject("") do |s, k|
        value = hash[k]
        value = Hash === value ? "(#{dump_params_keys(value)})" : ""
        s << ", " unless s.empty?
        s << "#{k}#{value}"
      end
    end
  end

  def setup
    @controller = TestController.new
    @integration_session = nil
  end

  def test_check_parameters
    with_test_route_set do
      get "/"
      assert_equal '', @controller.response.body
    end
  end

  def test_post_jsonapi
    with_test_route_set do
      post "/", { entry: { summary: 'content...', attributed: true }}.to_json,
           {'CONTENT_TYPE' => 'application/vnd.api+json' }

      assert_equal 'entry', @controller.response.body
      assert @controller.params.has_key?(:entry)
      assert_equal 'content...', @controller.params["entry"]['summary']
      assert @controller.params["entry"]['attributed']
    end
  end

  def test_put_jsonapi
    with_test_route_set do
      put "/", { entry: { summary: 'content...', attributed: true }}.to_json,
          {'CONTENT_TYPE' => 'application/vnd.api+json'}

      assert_equal 'entry', @controller.response.body
      assert @controller.params.has_key?(:entry)
      assert_equal 'content...', @controller.params["entry"]['summary']
      assert @controller.params["entry"]['attributed']
    end
  end

  # def test_post_jsonapi_with_no_data
  #   $stderr = StringIO.new
  #   with_test_route_set do
  #     post '/', { app: 'simple' }.to_json, 'CONTENT_TYPE' => 'application/vnd.api+json'
  #     assert_response 400
  #   end
  # ensure
  #   $stderr = STDERR
  # end

  def test_use_jsonapi_with_empty_request
    with_test_route_set do
      assert_nothing_raised { post "/", "", {'CONTENT_TYPE' => 'application/vnd.api+json'} }
      assert_equal '', @controller.response.body
    end
  end

  private

  def with_params_parsers(parsers = {})
    old_session = @integration_session
    @app = ActionDispatch::ParamsParser.new(app.routes, parsers)
    reset!
    yield
  ensure
    @integration_session = old_session
  end

  def with_test_route_set
    with_routing do |set|
      set.draw do
        match '/', :to => 'web_service_test/test#assign_parameters', :via => :all
      end
      yield
    end
  end
end
