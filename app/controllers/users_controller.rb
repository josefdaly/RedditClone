class UsersController < ApplicationController
  before_action :require_log_in, only: [:show]
  before_action :require_log_out, only: [:new, :create]

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Thank you for signing up"
      log_in!(@user)
    else
      flash.now[:errors] = @user.errors.full_messages
      render :new
    end
  end

  def new
    @user = User.new
  end

  def show
    @user = current_user
  end
end
