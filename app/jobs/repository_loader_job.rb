# frozen_string_literal: true

require 'octokit'

class RepositoryLoaderJob < ApplicationJob
  queue_as :default

  def perform(github_id, user)
    octokit_repository = ApplicationContainer[:octokit_client].get_repo_data(github_id, user)

    repository = Repository.find_or_create_by(github_id: github_id)

    return unless octokit_repository

    repository.update!(
      name: octokit_repository[:name],
      github_id: github_id,
      full_name: octokit_repository[:full_name],
      language: octokit_repository[:language],
      clone_url: octokit_repository[:clone_url],
      ssh_url: octokit_repository[:ssh_url]
    )

    ApplicationContainer[:octokit_client].set_webhook(github_id, user)

    check = repository.checks.build

    check.run!

    RepoCheckerJob.perform_later(repository, check)
  end
end
