# frozen_string_literal: true

class OctokitClientStub
  def self.client(_user)
    %w[test]
  end

  def self.allowed_repos(_user)
    %w[test]
  end

  def self.get_repo_data(_full_name, _user)
    {
      name: 'test',
      id: 123_456,
      full_name: 'test/test',
      language: 'Ruby',
      clone_url: 'test',
      ssh_url: 'test'
    }
  end

  def self.get_last_commit_sha(_full_name, _user, _truncated: true)
    'test'
  end

  def self.set_webhook(full_name, user); end
end
