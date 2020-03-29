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
            avatarUri
          }
        }
      QUERY
    )

    drugs = result[:drugs]
    expect(drugs[0]['id']).to eq drug.id
    expect(drugs[0]['name']).to eq drug.name
    expect(drugs[0]['description']).to eq drug.description
    expect(drugs[0]['avatarUri']).to eq drug.avatar_uri
  end
end
