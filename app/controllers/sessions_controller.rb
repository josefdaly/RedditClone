class SessionsController < ApplicationController
  before_action :require_log_out, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    user = User.find_by_credentials(user_params)
    if user
      log_in!(user)
    else
      @user = User.new(user_params)
      flash.now[:errors] = ["Invalid username or password"]
      render :new
    end
  end

  def destroy
    log_out!
  end
end
