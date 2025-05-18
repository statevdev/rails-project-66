# frozen_string_literal: true

class RepoCheckerJob < ApplicationJob
  queue_as :default

  def perform(check_id)
    check = Repository::Check.find_by(id: check_id)
    repository = check.repository

    github_id = repository.github_id
    token = repository.user.token
    full_name = repository.full_name
    clone_url = repository.clone_url
    language = repository.language

    github_user = ApplicationContainer[:octokit_client].client(token)

    commit_id = ApplicationContainer[:octokit_client].get_last_commit_sha(github_id, github_user)

    check.update!(commit_id: commit_id)

    output = ApplicationContainer[:repo_checker].run(
      full_name: full_name,
      clone_url: clone_url,
      language: language,
      commit_id: commit_id
    )

    check.finish!

    if output[:files].blank?
      check.update!(passed: true)
    else
      check.update!(
        output: output,
        passed: false
      )

      RepoCheckMailer.failure_report(check).deliver_later
    end
  rescue StandardError => e
    check.fail!
    Rails.logger.error(e)
  end
end
