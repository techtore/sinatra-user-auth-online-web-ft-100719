class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :views, Proc.new { File.join(root, "../views/") }

  configure do
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :home
  end

  get '/registrations/signup' do

    erb :'/registrations/signup'
    # renders the signup form view
  end

  post '/registrations' do
   @user = User.new(name: params["name"], email: params["email"], password: params["password"])
    @user.save
    session[:user_id] = @user.id
  
    redirect '/users/home'
    
    # handles POST request sent when user hits 'submit' on signup form. Code gets new user's info from params hash, creates new use, signs user in, and redirects to home
  end

  get '/sessions/login' do

    # the line of code below render the view page in app/views/sessions/login.erb. renders login form
    
    erb :'sessions/login'
  end

  post '/sessions' do
    
   @user = User.find_by(email: params["email"], password: params["password"])
     session[:user_id] = @user.id
      redirect '/users/home'
      
      # handles POST request sent when user hits 'submit' on signup form. Code grabs user info from params hash, matches info against DB, if matched signs user in
   end

  get '/sessions/logout' do
    session.clear
    redirect '/'
    # logs user out by clearing session hash
  end

   get '/users/home' do
    @user = User.find(session[:user_id])
    erb :'/users/home'
  end

end
