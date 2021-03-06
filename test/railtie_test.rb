require 'test_helper'

describe 'mimetype' do
  it 'is registered' do
    Mime::LOOKUP.must_include 'application/vnd.api+json'
  end
end

describe 'jsonapi renderer' do
  it 'is available' do
    ActionController::Renderers::RENDERERS.must_include :jsonapi
  end
end

describe 'jsonapi_error renderer' do
  it 'is available' do
    ActionController::Renderers::RENDERERS.must_include :jsonapi_error
  end
end
