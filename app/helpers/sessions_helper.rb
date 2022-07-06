module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
    if user.instance_of?(Staff)
      session[:is_staff] = true
    end
  end

  def current_user
    if session[:is_staff].nil?
      @current_user ||= Customer.find_by(id: session[:user_id])
    else
      @current_user ||= Staff.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def is_staff?
    current_user.instance_of?(Staff)
  end

  def log_out
    session.delete(:user_id)
    session.delete(:is_staff)
    @current_user = nil
  end
end
