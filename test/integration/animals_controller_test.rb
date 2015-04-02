require 'test_helper'

describe AnimalsController do
  let(:jsonapi_mime_type) { 'application/vnd.api+json' }
  let(:animal) { Animal.first }

  before do
    @request.headers['Accept'] = jsonapi_mime_type
  end

  describe 'content type' do
    it 'is the expected content type' do
      get :show, id: animal.id, format: :jsonapi
      response.headers['Content-Type'].must_match /#{Regexp.escape(jsonapi_mime_type)}/
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

  describe 'with non-existant id' do
    let(:id) { Animal.maximum(:id).next }
    let(:error) do
      {
        'status' => '404',
        'detail' => "Couldn't find Animal with 'id'=#{id}"
      }
    end

    it 'returns Not Found' do
      get :show, id: id
      must_respond_with 404
      response.json_body['errors'].must_include error
    end
  end
end
