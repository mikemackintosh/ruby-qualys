# frozen_string_literal: true

require 'spec_helper'
require 'rubygems'

describe Qualys::Api do
  describe 'api_get' do
    let(:query) { Qualys::Api.api_get('/scan/', query: { action: 'list' }) }
    let(:wrong_query) { Qualys::Api.api_get('/scan') }
    let(:not_existing_query) { Qualys::Api.api_get('/nonExisting', query: { action: 'list' }) }

    it 'query the API' do
      VCR.use_cassette('api_get') do
        expect(query.response.code).to eq '200'
      end
    end
    it 'raises appropriatly' do
      VCR.use_cassette('unlogged') do
        expect { query }.to raise_error(Qualys::Api::AuthorizationRequired, 'Please Login Before Communicating With The API')
      end

      VCR.use_cassette('wrong') do
        expect { wrong_query }.to raise_error(Qualys::Api::InvalidResponse)
      end
    end
  end
end
