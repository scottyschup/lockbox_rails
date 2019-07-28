# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  layout "application"

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
    @resource = resource_class.find_by(
      reset_password_token: params[:reset_password_token]
    )
    super
  end

  # PUT /resource/password
  def update
    super do |resource|
      if resource.errors.empty?
        resource.update(update_password_params)
      end
    end
  end

  protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  def update_password_params
    # Devise does not use these params to update the password itself, hence
    # the absence of password and password_confirmation
    params.require(:user).permit(:name, :email)
  end
end
