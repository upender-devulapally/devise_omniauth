class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,:confirmable,
         :recoverable, :rememberable, :trackable, :validatable , :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me ,:twitter_uid ,:twitter_confirmation_token,
                  :linkedin_uid ,:linkedin_confirmation_token


#--- Devise with Omniauth follow below -----------------
# https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview
# for facebook followed https://github.com/mkdynamic/omniauth-facebook

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"]
      end
    end
  end


  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    puts "##############   #{data.inspect}"
    if user = self.find_by_email(data.email)
      user.confirm! unless user.confirmed?
      user
    else # Create a user with a stub password.
      user = User.new(:email => data.email, :password => Devise.friendly_token[0,20], :type => 'social')
      user.skip_confirmation!
      user.save!
      user
    end
  end

  def self.find_for_twitter_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    puts "##############   #{data.inspect}"
    if user = self.find_by_twitter_uid(data.id)
      user
    else # Create a user with a stub password.
      puts "In Else"
      #self.create!(:email => data.email, :password => Devise.friendly_token[0,20])
      User.new
    end
  end

  def self.find_for_linkedin_oauth(access_token, signed_in_resource=nil)
    data = access_token.extra.raw_info
    puts "##############   #{data.inspect}"
    if user = self.find_by_linkedin_uid(data.id)
      user
    else # Create a user with a stub password.
      puts "In Else"
      #self.create!(:email => data.email, :password => Devise.friendly_token[0,20])
      User.new
    end
  end

  def self.find_for_open_id(access_token, signed_in_resource=nil)
    data = access_token.info
    puts "##############   #{data.inspect}"
    if user = User.where(:email => data["email"]).first
      user.confirm! unless user.confirmed?
      user
    else
      user = User.new(:email =>  data["email"], :password => Devise.friendly_token[0,20], :type => 'social')
      user.skip_confirmation!
      user.save!
      user
    end
  end

end
