# frozen_string_literal: true

class OctokitClientStub
  def self.client(_user)
    %w[test]
  end

  def self.allowed_repos(_user)
    %w[test]
  end

  def self.find_allowed_repo(_full_name, _user)
    {
      name: 'test',
      id: 'test',
      full_name: 'test/test',
      language: 'Ruby',
      clone_url: 'test',
      ssh_url: 'test'
    }
  end
end
