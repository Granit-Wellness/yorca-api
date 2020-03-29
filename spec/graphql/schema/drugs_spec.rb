# frozen_string_literal: true

require 'spec_helper'

describe Yorca::Graphql::Schema, '.execute' do
  it 'returns drugs' do
    drug = Models::Drug.create(
      name: 'heroin',
      description: 'really bad',
      avatar_uri: 'http://some-image.com/',
    )

    result = execute_query(
      <<~QUERY
        query {
          drugs {
            id
            name
            description
          }
        }
      QUERY
    )

    drugs = result[:drugs]
    expect(drugs[0]['id']).to eq drug.id
  end
end
