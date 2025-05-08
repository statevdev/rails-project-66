# frozen_string_literal: true

require 'octokit'

class RepositoryLoaderJob < ApplicationJob
  queue_as :default

  def perform(full_name, user)
    octokit_repository = ApplicationContainer[:octokit_client].get_repo_data(full_name, user)

    repository = Repository.find_or_create_by(full_name: full_name)

    return unless octokit_repository

    repository.update!(
      name: octokit_repository[:name],
      github_id: octokit_repository[:id],
      full_name: octokit_repository[:full_name],
      language: octokit_repository[:language],
      clone_url: octokit_repository[:clone_url],
      ssh_url: octokit_repository[:ssh_url]
    )
  end
end
