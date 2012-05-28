class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :verify_authenticity_token, :only => [:google]
  def facebook
    # You need to implement the method below in your model
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def twitter
    # You need to implement the method below in your model
    data = request.env["omniauth.auth"].extra.raw_info
    @user = User.find_for_twitter_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Twitter"
      sign_in_and_redirect @user, :event => :authentication
    else
      #The problem is with session["devise.facebook_data"] = env["omniauth.auth"].
      #Twitter's response contains an extra section that is very large and does not fit in the session.
      #One option is to store env["omniauth.auth"].except("extra") in the session instead.
      # session[:twitter_uid] = data.id
      redirect_to fetch_email_from_twitter_path(:twitter_uid=>data.id) ,:notice=>'Your Authorized from Twitter.Provide your Email so further communication made.'
    end
  end

  def linkedin
    # You need to implement the method below in your model
    data = request.env["omniauth.auth"].extra.raw_info
    @user = User.find_for_linkedin_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "LinkedIn"
      sign_in_and_redirect @user, :event => :authentication
    else
      #The problem is with session["devise.facebook_data"] = env["omniauth.auth"].
      #Twitter's response contains an extra section that is very large and does not fit in the session.
      #One option is to store env["omniauth.auth"].except("extra") in the session instead.
      # session[:twitter_uid] = data.id
      redirect_to fetch_email_from_linkedin_path(:linkedin_uid=>data.id) ,:notice=>'Your Authorized from LinkedIn.Provide your Email so further communication made.'
    end
  end

  def google
    @user = User.find_for_open_id(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.google_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end


  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    # Or alternatively,
    # raise ActionController::RoutingError.new('Not Found')
  end

end

