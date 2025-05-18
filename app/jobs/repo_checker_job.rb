# frozen_string_literal: true

class RepoCheckerJob < ApplicationJob
  queue_as :default

  def perform(repository, check)
    github_id = repository.github_id
    user = repository.user

    commit_id = ApplicationContainer[:octokit_client].get_last_commit_sha(github_id, user)

    check.update!(commit_id: commit_id)

    output = ApplicationContainer[:repo_checker].run(repository, check)

    if output[:files].blank?
      check.update!(passed: true)
    else
      check.update!(
        output: output,
        passed: false
      )

      RepoCheckMailer.failure_report(repository.user, check).deliver_later
    end

    check.finish!
  rescue StandartError
    check.fail!
  end
end
