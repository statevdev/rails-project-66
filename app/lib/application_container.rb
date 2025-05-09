# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :octokit_client, -> { OctokitClientStub }
    register :repo_checker, -> { RepoCheckerStub }
  else
    register :octokit_client, -> { OctokitClient }
    register :repo_checker, -> { RepoChecker }
  end
end
