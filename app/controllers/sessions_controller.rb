class SessionsController < ApplicationController
  protect_from_forgery :except => [:create, :failure]
  
  def create
    unless @auth = Authorization.find_from_hash(auth_hash)
      # Create a new user or add an auth to existing user, depending on
      # whether there is already a user signed in.
      @auth = Authorization.create_from_hash(auth_hash, current_user)
    end
    # Log the authorizing user in.
    self.current_user = @auth.user
    
    flash[:success] = 'Logged in succesfully'
    redirect_back_or_default('/')
  end
  
  def destroy
    flash[:success] = 'You have been logged out'
    session[:user_id] = nil
    
    redirect_back_or_default('/')
  end
  
  def failure
    flash[:notice] = params[:message] # if using sinatra-flash or rack-flash
    redirect '/'
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
