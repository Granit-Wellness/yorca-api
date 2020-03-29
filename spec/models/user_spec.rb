# frozen_string_literal: true

require 'spec_helper'

describe Yorca::Models::Post do
  describe '#create' do
    context 'with no annonymous_name or avatar_uri' do
      it 'sets random values before save' do
        user = Models::User.create(email: 'david.t.noah@gmail.com', password: 'password')

        expect(user.annonymous_name).to be_present
        expect(user.avatar_uri).to be_present
      end
    end
  end
end
