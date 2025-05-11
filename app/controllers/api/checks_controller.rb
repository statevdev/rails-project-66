# frozen_string_literal: true

class Api::ChecksController < Api::ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    json = JSON.parse(request.body.read)

    full_name = json['repository']['full_name']

    repository = Repository.find_by(full_name: full_name)

    check = repository.checks.create!

    check.run!

    RepoCheckerJob.perform_later(repository, check)

    head :ok
  end
end
