# frozen_string_literal: true

require 'spec_helper'

describe Yorca::Routes::Graphql do
  describe 'POST /graphql' do
    module Yorca
      module Graphql
        class Query
          field :broken_field, String, null: false
          field :ping, String, null: false

          def broken_field
            raise StandardError
          end

          def ping
            'pong'
          end
        end
      end
    end

    it 'renders data' do
      post_json '/graphql', { query: '{ ping }' }

      expect(last_response.status).to eq(200)
      expect(last_response_body).to include(
        'data' => { 'ping' => 'pong' },
      )
    end

    it 'does not serialize exceptions outside development' do
      expect {
        post_json '/graphql', { query: '{ brokenField }' }

        last_response
      }.to raise_error(StandardError)
    end
  end
end
