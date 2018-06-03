class SessionsController < ApplicationController
    def new
      if logged_in? 
        redirect_to home_path, notice: "You have already logged_in"
      end

    end

    def create
      user = User.find_by_username(params[:username].downcase)
      if user && user.active && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to home_path, notice: "Logged in!"
      else
        flash[:error] = "Username or password is invalid"
        render "new"
      end
    end

    def destroy
      session[:user_id] = nil
      redirect_to home_path, notice: "Logged out!"
    end
  end