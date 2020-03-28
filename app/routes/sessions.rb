module Yorca
  module Routes
    module Dashboard
      class Sessions < Base
        get '/sessions/user' do
          json current_user
        end

        get '/login' do
          if current_user?
            redirect '/'
          else
            erb :login, layout: :login_with_cta
          end
        end

        post '/login' do
          user = User.authenticate(
            params[:email], params[:password]
          )

          if user
            self.current_user = user
          else
            @failed = true
            halt erb :login, layout: :modal
          end

          if back = session[:back]
            session.delete :back
            redirect back
          else
            redirect '/integrate'
          end
        end

        get '/logout' do
          session.destroy
          redirect '/'
        end

        get '/forgot' do
          erb :forgot, layout: :modal
        end

        post '/forgot' do
          @user = User.for_email(params[:email])

          if @user
            @user.reset!
            Mailer.reset!(@user)
          end

          @sent = true

          erb :forgot, layout: :modal
        end

        get '/token/:token' do
          user = User.for_token(params[:token])
          redirect '/' unless user

          self.current_user = user
          redirect '/'
        end

        get '/reset/:token' do
          @user = User.for_token(params[:token])
          redirect '/' unless @user

          erb :reset, layout: :modal
        end

        post '/reset' do
          user = User.for_token(params[:token])
          redirect '/' unless user

          user.password = params[:password]
          user.reset_token = nil
          user.save!

          self.current_user = user

          redirect '/'
        end
      end
    end
  end
end
