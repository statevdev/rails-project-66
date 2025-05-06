# frozen_string_literal: true

module Web
  class AuthController < Web::ApplicationController
    def callback
      auth = request.env['omniauth.auth']

      user = User.find_or_initialize_by(email: auth.info.email)

      user.nickname = auth.info.nickname
      user.token = auth.credentials.token
      user.save!

      sign_in user

      redirect_to root_path, notice: t('sign_in')
    end

    def destroy
      sign_out
      redirect_to root_path, notice: t('sign_out')
    end
  end
end
