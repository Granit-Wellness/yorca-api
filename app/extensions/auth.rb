# frozen_string_literal: true

module Yorca
  module Extensions
    module Auth extend self
      module Helpers
        def current_user_from_session
          user_id = session[:user_id]
          user_id && User[user_id]
        end

        def current_user=(user)
          session[:user_id] = user && user.id
        end

        def current_user
          return @current_user if defined?(@current_user)
          @current_user = current_user_from_session

          @current_user
        end

        def current_user?
          !!current_user
        end
      end
    end
  end
end
