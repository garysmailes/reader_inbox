class RegistrationsController < ApplicationController
  # Your app is deny-by-default (ApplicationController requires auth),
  # so sign-up must be explicitly public.
  allow_unauthenticated_access only: %i[new create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      # Use Rails 8 authentication defaults (defined in Authentication concern)
      start_new_session_for(@user)
      redirect_to inbox_path, notice: "Welcome."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end
end
