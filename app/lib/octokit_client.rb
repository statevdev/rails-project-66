# frozen_string_literal: true

class OctokitClient
  def self.client(user)
    Octokit::Client.new access_token: user.token, auto_paginate: true
  end

  def self.allowed_repos(user)
    client(user).repos.filter_map do |repo|
      if Repository.language.value?(repo[:language])
        [repo[:full_name], repo[:id]]
      end
    end
  end

  def self.get_repo_data(github_id, user)
    client(user).repository(github_id.to_i)
  end

  def self.get_last_commit_sha(github_id, user, truncated: true)
    client = client(user)

    repo_data = get_repo_data(github_id, user)

    commits = client.commits(github_id, repo_data.default_branch)

    return commits.first.sha[0, 7] if truncated

    commits.first.sha
  end

  def self.set_webhook(full_name, user)
    client = client(user)

    url = Rails.application.routes.url_helpers.url_for(
      controller: 'api/checks',
      action: 'create',
      only_path: false,
      host: Rails.application.config.default_url_options[:host]
    )

    existing_hooks = client.hooks(full_name)

    already_exists = existing_hooks.any? do |hook|
      hook[:config][:url] == url
    end

    return if already_exists

    client.create_hook(
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
