module Yorca
  module Routes
    class Drugs < Base
      get '/drugs' do
        json Models::Drug.all
      end
    end
  end
end
