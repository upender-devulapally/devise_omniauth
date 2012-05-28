class FetchEmailMailer < ActionMailer::Base
  default :from => "info@konnektin.com"

  def confirm_twitter(email,token,uid)
    @email = email
    @token = token
    @url  = "http://localhost:3000/confirm_twitter/#{token}/#{uid}"
    mail(:to => email, :subject => "Confirm Your Twitter Account")
  end

  def confirm_linkedin(email,token,uid)
      @email = email
      @token = token
      @url  = "http://localhost:3000/confirm_linkedin/#{token}/#{uid}"
      mail(:to => email, :subject => "Confirm Your LinkedIn Account")
    end

end
