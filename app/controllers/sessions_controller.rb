class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:login_form, :create]

  def login_form
  end

  # def login
  #   username = params[:username]
  #   if username and user = User.find_by(username: username)
  #     session[:user_id] = user.id
  #     flash[:status] = :success
  #     flash[:result_text] = "Successfully logged in as existing user #{user.username}"
  #   else
  #     flash[:result_text] = "User not valid. Please log in or sign up with Github."
  #     redirect_to login_path
  #     return
  #   end
  #   redirect_to root_path
  # end

  def logout
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out"
    redirect_to root_path
  end

  def create
    @auth_hash = request.env['omniauth.auth']

    @user = User.find_by(uid: @auth_hash['uid'], provider: @auth_hash['provider'])

    if @user
      session[:user_id] = @user.id
      flash[:success] = "#{@user.username}, logged in !"
    else
      @user = User.new uid: @auth_hash['uid'], provider: @auth_hash['provider'], username: @auth_hash['info']['nickname'], email: @auth_hash['info']['email']
      if
        @user.save
        session[:user_id] = @user.id
        flash[:success] = "Welcome, #{@user.username}"
      else
        flash[:error] = "Unable to save user!"
      end
    end
    redirect_to root_path
  end
end
