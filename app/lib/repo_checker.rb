# frozen_string_literal: true

module RepoChecker
  def self.run(repository, check)
    cloner = RepoCloner.new(repository)
    cloner.clone

    runner = Linters::Rubocop::RubocopRunner.new(cloner.target_dir)
    runner.run(Linters::Rubocop::RubocopRunner::CMD)
    rubocop_json = runner.result

    rubocop = Linters::Rubocop::RubocopParser.new(rubocop_json, repository, check)

    return {} if rubocop.result.empty?

    rubocop.result
  end
end
