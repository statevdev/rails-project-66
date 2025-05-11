# frozen_string_literal: true

class RepoCheckMailer < ApplicationMailer
  def failure_report(user, check)
    @user = user
    @check = check

    mail(
      to: @user.email,
      subject: "Проверка репозитория не прошла: #{check.repository.full_name}"
    )
  end
end
