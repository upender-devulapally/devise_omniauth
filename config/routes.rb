DeviseOmniauth::Application.routes.draw do

  #tell Devise in which controller we will implement Omniauth callbacks
  devise_for :users, :controllers => {:omniauth_callbacks => "users/omniauth_callbacks" }

  ########### For Twitter ##################
  get '/fetch_email_from_twitter/:twitter_uid' => "users/fetch_email#fetch_email_from_twitter" , :as => :fetch_email_from_twitter
  post 'fetch_email_from_twitter_and_create' => "users/fetch_email#fetch_email_from_twitter_and_create" , :as => :fetch_email_from_twitter_and_create
  match "/confirm_twitter/:token/:twitter_uid"=>"users/fetch_email#confirm_twitter",:as=>:confirm_twitter

  ########## For Linked In ##################
  get '/fetch_email_from_linkedin/:linkedin_uid' => "users/fetch_email#fetch_email_from_linkedin" , :as => :fetch_email_from_linkedin
  post 'fetch_email_from_linkedin_and_create' => "users/fetch_email#fetch_email_from_linkedin_and_create" , :as => :fetch_email_from_linkedin_and_create
  match "/confirm_linkedin/:token/:linkedin_uid"=>"users/fetch_email#confirm_linkedin",:as=>:confirm_linkedin

  devise_scope :user do
    get "/login" => "devise/sessions#new"
    delete "/logout" => "devise/sessions#destroy"
    get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  end

  get "home/index"
  root :to => "home#index"
end
