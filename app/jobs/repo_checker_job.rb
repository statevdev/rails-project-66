# frozen_string_literal: true

class RepoCheckerJob < ApplicationJob
  queue_as :default

  def perform(repository, check)
    repo_name = repository.full_name
    user = repository.user

    commit_id = ApplicationContainer[:octokit_client].get_last_commit_sha(repo_name, user)

    check.update!(commit_id: commit_id)

    output = RepoChecker.run(repository, check)

    if output['files'].nil?
      check.update!(passed: true)
    else
      check.update!(
        output: output,
        passed: false
      )
    end
    check.finish!
  rescue StandardError => e
    Rails.logger.error("Произошла ошибка: #{e.message}")
    check.fail!
  end
end
