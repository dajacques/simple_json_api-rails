require 'params_parser/helper'

class JsonApiParamsParsingTest < ActionDispatch::IntegrationTest
  class TestController < ActionController::Base
    class << self
      attr_accessor :last_request_parameters
      attr_accessor :last_request
    end

    def parse
      self.class.last_request_parameters = request.request_parameters
      self.class.last_request = request
      head :ok
    end
  end

  def teardown
    TestController.last_request_parameters = nil
    TestController.last_request = nil
  end

  test "parses a strict rack.input" do
    class Linted
      undef call if method_defined?(:call)
      def call(env)
        bar = env['action_dispatch.request.request_parameters']['foo']
        result = { ok: 'bar' }.to_json
        [200, {"Content-Type" => 'application/vnd.api+json', "Content-Length" => result.length.to_s}, [result]]
      end
    end
    req = Rack::MockRequest.new(SimpleJsonApi::Rails::JsonApiParamsParser.new(Linted.new))
    resp = req.post('/', "CONTENT_TYPE" => 'application/vnd.api+json', :input => { foo: 'bar' }.to_json, :lint => true)
    assert_equal({ ok: 'bar' }.to_json, resp.body)
  end

  def assert_parses(expected, json)
    with_test_routing do
      post "/parse", json, default_headers
      assert_response :ok
      assert_equal(expected, TestController.last_request_parameters)
    end
  end

  test "nils are stripped from collections" do
    assert_parses(
      {"hash" => { "person" => nil} },
      {"hash" => { "person" => nil} }.to_json)
    assert_parses(
      {"hash" => { "person" => ['foo']} },
      {"hash" => { "person" => ['foo']} }.to_json)
  end

  test "parses hash params" do
    with_test_routing do
      json = {"person" => {"name" => "David"}}.to_json
      post "/parse", json, default_headers
      assert_response :ok
      assert_equal({"person" => {"name" => "David"}}, TestController.last_request_parameters)
    end
  end

  test "logs error if parsing unsuccessful" do
    with_test_routing do
      output = StringIO.new
      json = '{"abc":}'
      post "/parse", json, default_headers.merge('action_dispatch.show_exceptions' => true, 'action_dispatch.logger' => ActiveSupport::Logger.new(output))
      assert_response :bad_request
      output.rewind && err = output.read
      assert err =~ /Error occurred while parsing request parameters/
    end
  end

  test "occurring a parse error if parsing unsuccessful" do
    with_test_routing do
      begin
        $stderr = StringIO.new # suppress the log
        json = '{"abc":}'
        exception = assert_raise(ActionDispatch::ParamsParser::ParseError) { post "/parse", json, default_headers.merge('action_dispatch.show_exceptions' => false) }
        assert_equal JSON::ParserError, exception.original_exception.class
        assert_equal exception.original_exception.message, exception.message
      ensure
        $stderr = STDERR
      end
    end
  end

  test "rewinds body if it implements rewind" do
    json = { person: { name: 'Marie' }}.to_json

    with_test_routing do
      post "/parse", json, default_headers
      assert_equal TestController.last_request.body.read, json
    end
  end

  private

  def with_test_routing
    with_routing do |set|
      set.draw do
        post ':action', :to => ::JsonApiParamsParsingTest::TestController
      end
      yield
    end
  end

  def default_headers
    {'CONTENT_TYPE' => 'application/vnd.api+json'}
  end
end
