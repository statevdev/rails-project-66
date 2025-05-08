# frozen_string_literal: true

require_relative 'repo_checker/repo_cloner'
require_relative 'repo_checker/rubocop_runner'
require_relative 'repo_checker/rubocop_result'

require_relative '../../config/environment'

module RepoChecker
  def self.run(repository, check)
    cloner = RepoCloner.new(repository)
    cloner.clone

    runner = RubocopRunner.new(cloner.target_dir)
    rubocop_json = runner.run

    rubocop = RubocopResult.new(rubocop_json, repository, check)

    return {} if rubocop.result.empty?

    rubocop.result
  end
end

# repo = RepoChecker.run(Repository.last)
# puts repo.to_json
