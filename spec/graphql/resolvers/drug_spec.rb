# frozen_string_literal: true

require 'spec_helper'

describe Yorca::Graphql::Resolvers::Drug do
  it 'returns a single drug' do
    drug = Models::Drug.create(
      name: 'heroin',
      description: 'really bad',
      avatar_uri: 'http://some-image.com/',
    )

    result = resolve_described_class(
      arguments: {
        id: drug.id,
      },
    )

    expect(result).to eq drug
  end
end
