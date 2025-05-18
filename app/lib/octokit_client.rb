# frozen_string_literal: true

class OctokitClient
  def self.client(token)
    Octokit::Client.new access_token: token, auto_paginate: true
  end

  def self.allowed_repos(github_user)
    github_user.repos.filter_map do |repo|
      if Repository.language.value?(repo[:language])
        [repo[:full_name], repo[:id]]
      end
    end
  end

  def self.get_repo_data(github_id, github_user)
    github_user.repository(github_id.to_i)
  end

  def self.get_last_commit_sha(github_id, github_user, truncated: true)
    repo_data = get_repo_data(github_id, github_user)

    commits = github_user.commits(github_id, repo_data.default_branch)

    return commits.first.sha[0, 7] if truncated

    commits.first.sha
  end

  def self.set_webhook(full_name, github_user)
    url = Rails.application.routes.url_helpers.url_for(
      controller: 'api/checks',
      action: 'create',
      only_path: false,
      host: Rails.application.config.default_url_options[:host]
    )

    existing_hooks = github_user.hooks(full_name)

    already_exists = existing_hooks.any? do |hook|
      hook[:config][:url] == url
    end

    return if already_exists

    github_user.create_hook(
      full_name,
      'web',
      {
        url: url,
        content_type: 'json'
      },
      {
        events: ['push'],
        active: true
      }
    )
  end
end
