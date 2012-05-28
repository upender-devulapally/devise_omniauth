class ApplicationController < ActionController::Base
  protect_from_forgery

  # Overwriting the sign_out redirect path method  private

  def after_sign_in_path_for(resource_or_scope)
    case resource_or_scope
      when :user, User
        #session[:twitter_uid] = nil if session[:twitter_uid]
        root_path
      else
        super
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    case resource_or_scope
      when :user, User
       #session[:twitter_uid] = nil if session[:twitter_uid]
        login_path
      else
        super
    end
  end
end
