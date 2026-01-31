class RegistrationsController < ApplicationController
  before_action :require_no_authentication

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      # Rails 8 auth generator uses a Session model; create one to sign in.
      session_record = @user.sessions.create!(
        user_agent: request.user_agent,
        ip_address: request.remote_ip
      )

      cookies.signed.permanent[:session_token] = session_record.token
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
