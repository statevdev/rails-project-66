# frozen_string_literal: true

class RepoCheckerJob < ApplicationJob
  queue_as :default

  def perform(repository, check)
    repo_name = repository.full_name
    user = repository.user

    commit_id = ApplicationContainer[:octokit_client].get_last_commit_sha(repo_name, user)

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

    if check.may_finish?
      check.finish!
    else
      check.fail!
    end
  end
end
