# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include AuthConcern
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :set_locale_from_headers

  def set_locale_from_headers
    logger.debug(request.env['HTTP_ACCEPT_LANGUAGE'])

    locale = request.env['HTTP_ACCEPT_LANGUAGE']&.scan(/^[a-z]{2}/)&.first

    logger.debug("LOCALE: #{locale}")

    I18n.locale = if locale.present? && I18n.available_locales.include?(locale.to_sym)
                    locale
                  else
                    I18n.default_locale
                  end
  end
end
