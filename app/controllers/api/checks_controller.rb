# frozen_string_literal: true

class Api::ChecksController < Api::ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    full_name = params[:repository][:full_name]

    repository = Repository.find_by(full_name: full_name)

    return head :not_found unless repository

    check = repository.checks.create!

    check.run!

    RepoCheckerJob.perform_later(check.id)

    head :ok
  end
end
