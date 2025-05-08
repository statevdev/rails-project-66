# frozen_string_literal: true

class OctokitClient
  def self.client(user)
    Octokit::Client.new access_token: user.token, auto_paginate: true
  end

  def self.allowed_repos(user)
    client(user).repos.filter_map do |repo|
      if Repository.language.values.include?(repo[:language])
        repo[:full_name]
      end
    end
  end

  def self.get_repo_data(full_name, user)
    client(user).repository(full_name)
  end

  def self.get_last_commit_sha(full_name, user, truncated = true)
    client = client(user)

    repo_data = get_repo_data(full_name, user)

    commits = client.commits(full_name, repo_data.default_branch)

    return commits.first.sha[0, 7] if truncated

    commits.first.sha
  end
end
