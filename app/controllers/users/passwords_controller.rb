# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  layout "application", except: [:new]

  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  def edit
    set_existing_user
    super
  end

  # PUT /resource/password
  def update
    set_existing_user
    super do |resource|
      if resource.errors.empty?
        resource.update(update_password_params)
      end
    end
  end

  protected

  def after_resetting_password_path_for(resource)
    if resource.sign_in_count > 1
      super(resource)
    else
      send_user_confirmed_email
      onboarding_success_path
    end
  end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  def update_password_params
    # Devise does not use these params to update the password itself, hence
    # the absence of password and password_confirmation
    params.require(:user).permit(:name)
  end

  private

  def send_user_confirmed_email
    UserMailer
      .with(confirmed_user: resource)
      .user_confirmation_completed
      .deliver_now
  end

  def set_existing_user
    # Defining @existing_user is a hack to display the preset email for
    # newly created clinic users, and to determine whether the user has
    # signed in before so we can display the onboarding success message.
    # The variable can't be named @user or @resource as the super call
    # will assign a newly initialized User to those variables.
    token = Devise.token_generator.digest(
      self, :reset_password_token, params[:reset_password_token] || params[:user][:reset_password_token]
    )
    @existing_user = User.find_by(reset_password_token: token)
  end
end
