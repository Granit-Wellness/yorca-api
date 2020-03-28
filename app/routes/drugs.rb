# Sample routes -- does not work!

module Sample
  module Routes
    class Drugs < Base
      get '/drugs' do
        json Models::Drug.all
      end
    end
  end
end
