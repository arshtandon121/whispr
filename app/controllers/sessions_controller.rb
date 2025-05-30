class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      session[:remember_token] = user.remember_token
      
      redirect_to root_path, notice: "Welcome back!"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    session.delete(:remember_token)
    redirect_to root_path, notice: "Logged out successfully"
  end
end 