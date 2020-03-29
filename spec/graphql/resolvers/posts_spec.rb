# frozen_string_literal: true

require 'spec_helper'

describe Yorca::Graphql::Resolvers::Posts do
  it 'returns an array of posts, most recent first' do
    Models::Post.create(
      user_id: current_user.id,
      title: 'Some post',
      body: 'a story',
    )

    newest_post = Models::Post.create(
      user_id: current_user.id,
      title: 'New post',
      body: 'a story',
    )

    result = resolve_described_class

    expect(result.length).to eq 2
    expect(result[0][:title]).to eq newest_post.title
  end
end
