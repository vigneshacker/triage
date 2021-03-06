class SessionsController < Devise::SessionsController
  def create
    # Move the user parameters into their subclass variants. Modifying the
    # rack request parameters directly as Warden operates at a lower level.
    request.params['directory_user'] = request.params['database_user'] = request.params['user']

    # Try to find the user signing in.
    user = User.where(username: request.params['user']['username']).first

    if user.is_a? DirectoryUser
      # Try to authenticate as a directory user.
      user_class = :directory_user
      self.resource = warden.authenticate scope: user_class
    elsif user.is_a? DatabaseUser
      # Try to authenticate as a database user.
      user_class = :database_user
      self.resource = warden.authenticate scope: user_class
    end

    if self.resource.nil?
      flash[:error] = t 'sessions.create.failure'
      return redirect_to new_session_path
    end

    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(user_class, resource)
    respond_with resource, :location => after_sign_in_path_for(resource)
  end

  def destroy
    set_flash_message :notice, :signed_out if sign_out && is_navigational_format?

    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to new_session_path }
    end
  end
end
