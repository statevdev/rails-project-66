# frozen_string_literal: true

require 'octokit'

class RepositoryLoaderJob < ApplicationJob
  queue_as :default

  def perform(github_id)
    repository = Repository.find_by(github_id: github_id)

    token = repository.user.token

    github_user = ApplicationContainer[:octokit_client].client(token)

    octokit_repository = ApplicationContainer[:octokit_client].get_repo_data(github_id, github_user)

    return unless octokit_repository

    repository.update!(
      name: octokit_repository[:name],
      github_id: github_id,
      full_name: octokit_repository[:full_name],
      language: octokit_repository[:language],
      clone_url: octokit_repository[:clone_url],
      ssh_url: octokit_repository[:ssh_url]
    )

    ApplicationContainer[:octokit_client].set_webhook(repository.full_name, github_user)
  end
end
