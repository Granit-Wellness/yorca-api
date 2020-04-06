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
      <<~QUERY,
        query Drug($id: ID!) {
          drug(id: $id) {
            id
            name
            description
            avatarUri
          }
        }
      QUERY
      variables: {
        id: drug.id,
      },
    )

    expect(result[:drug]['id']).to eq drug.id
    expect(result[:drug]['name']).to eq drug.name
    expect(result[:drug]['description']).to eq drug.description
    expect(result[:drug]['avatarUri']).to eq drug.avatar_uri
  end
end
