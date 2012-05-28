class Users::FetchEmailController < ApplicationController
  def fetch_email_from_twitter
    puts "YES#######################  #{params[:twitter_uid]}"
    @user = User.new(:twitter_uid=>params[:twitter_uid])
  end
  def fetch_email_from_twitter_and_create
    @user = User.find_by_email(params[:user][:email])
    if @user
      token = Digest::SHA1.hexdigest([Time.now, rand].join)
      @user.update_attribute('twitter_confirmation_token',token)
      FetchEmailMailer.confirm_twitter(@user.email,token,params[:user][:twitter_uid]).deliver
      redirect_to fetch_email_from_twitter_url(:twitter_uid=>params[:user][:twitter_uid]),:notice=>"Email already exists.An Email has been sent You have to confirm your account to club with twitter."
    else
      @user = User.create!(:email=>params[:user][:email],:twitter_uid=>params[:user][:twitter_uid], :password => Devise.friendly_token[0,20])
      @user.send_confirmation_instructions
      redirect_to fetch_email_from_twitter_url(:twitter_uid=>params[:user][:twitter_uid]),:notice=>"Instrucations has been sent to your mail.please activate"
    end
  end

  def confirm_twitter
    @user = User.find_by_twitter_confirmation_token(params[:token])
    if @user
      @user.update_attribute('twitter_uid',params[:twitter_uid])
      flash[:notice] = "Your Account Confirmed with Twitter, Now you can login with both twitter and konnektin accounts"
      sign_in_and_redirect @user, :event => :authentication
    else
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
  end


  def fetch_email_from_linkedin
    puts "YES#######################  #{params[:linkedin_uid]}"
    @user = User.new(:linkedin_uid=>params[:linkedin_uid])
  end
  def fetch_email_from_linkedin_and_create
    @user = User.find_by_email(params[:user][:email])
    if @user
      token = Digest::SHA1.hexdigest([Time.now, rand].join)
      @user.update_attribute('linkedin_confirmation_token',token)
      FetchEmailMailer.confirm_linkedin(@user.email,token,params[:user][:linkedin_uid]).deliver
      redirect_to fetch_email_from_linkedin_url(:linkedin_uid=>params[:user][:linkedin_uid]),:notice=>"Email already exists.An Email has been sent You have to confirm your account to club with linkedin."
    else
      @user = User.create!(:email=>params[:user][:email],:linkedin_uid=>params[:user][:linkedin_uid], :password => Devise.friendly_token[0,20])
      @user.send_confirmation_instructions
      redirect_to fetch_email_from_linkedin_url(:linkedin_uid=>params[:user][:linkedin_uid]),:notice=>"Instrucations has been sent to your mail.please activate"
    end
  end

  def confirm_linkedin
    @user = User.find_by_linkedin_confirmation_token(params[:token])
    if @user
      @user.update_attribute('linkedin_uid',params[:linkedin_uid])
      flash[:notice] = "Your Account Confirmed with linkedin, Now you can login with both linkedin and konnektin accounts"
      sign_in_and_redirect @user, :event => :authentication
    else
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
  end

end
