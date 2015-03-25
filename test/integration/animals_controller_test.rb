require 'test_helper'

describe AnimalsController do
  let(:animal) { Animal.first }

  describe 'content type' do
    let(:mime_type) { 'application/vnd.api+json' }

    it 'is the expected content type' do
      get :show, id: animal.id, format: :jsonapi
      response.headers['Content-Type'].must_match /#{Regexp.escape(mime_type)}/
    end
  end

  describe 'rendering' do
    let(:rendered) { 'bob' }

    it 'uses SimpleJsonApi.render' do
      SimpleJsonApi.stub :render, rendered do
        get :show, id: animal.id, format: :jsonapi
        response.body.must_equal rendered
      end
    end
  end
end
