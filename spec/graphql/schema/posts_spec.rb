# frozen_string_literal: true

require 'spec_helper'

describe Yorca::Graphql::Schema, '.execute' do
  it 'returns posts' do
    post = Models::Post.create(
      user_id: current_user.id,
      title: 'Some post',
      body: 'a story',
    )

    result = execute_query(
      <<~QUERY
        query {
          posts {
            id
            title
            body
            createdAt
            user {
              id
              email
            }
          }
        }
      QUERY
    )

    posts = result[:posts]
    expect(posts[0]['id']).to eq post.id
    expect(posts[0]['title']).to eq post.title
    expect(posts[0]['body']).to eq post.body
    expect(posts[0]['user']['id']).to eq current_user.id
    expect(posts[0]['createdAt'].to_datetime).to be_within(1.second).of post.created_at.to_datetime
  end
end
