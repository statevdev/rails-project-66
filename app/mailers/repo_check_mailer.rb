# frozen_string_literal: true

class RepoCheckMailer < ApplicationMailer
  def failure_report(check)
    @check = check

    mail(
      to: @check.repository.user.email,
      subject: "#{t('.failed')} #{@check.repository.full_name}"
    )
  end
end
