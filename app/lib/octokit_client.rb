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

  def self.find_allowed_repo(full_name, user)
    client(user).repos.find do |repo|
      repo[:full_name] == full_name
    end
  end
end
