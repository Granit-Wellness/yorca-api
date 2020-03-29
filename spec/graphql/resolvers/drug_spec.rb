# frozen_string_literal: true

require 'spec_helper'

describe Yorca::Graphql::Resolvers::Drugs do
  it 'returns an array of drugs' do
    drug = Models::Drug.create(
      name: 'heroin',
      description: 'really bad',
      avatar_uri: 'http://some-image.com/',
    )

    result = resolve_described_class

    expect(result).to eq [drug]
  end
end
