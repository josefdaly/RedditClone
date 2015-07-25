class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?
  protect_from_forgery with: :exception

  def current_user
    @current_user ||= User.find_by(session_token: session[:session_token])
  end

  def log_in!(user)
    session[:session_token] = user.reset_session_token!
    redirect_to :root
  end

  def logged_in?
    !!current_user
  end

  def log_out!
    current_user.reset_session_token!
    session[:session_token] = nil
    redirect_to new_session_url
  end

  def require_log_in
    redirect_to new_session_url unless logged_in?
  end

  def require_log_out
    redirect_to user_url if logged_in?
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

  def require_moderator
    unless current_user == Sub.find(params[:id]).moderator
      redirect_to sub_url(params[:id])
    end
  end

  def require_author
    unless current_user == Post.find(params[:id]).author
      redirect_to post_url(params[:id])
    end
  end

  def require_owner(owner_name, class_name)
    owner = constantize(class_name).find(params[:id]).send(owner_name)
    object_url = send("#{class_name.underscore}_url", params[:id])
    redirect_to object_url unless current_user == owner
  end

end
