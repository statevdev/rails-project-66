# frozen_string_literal: true

module RepoChecker
  def self.run(repository, check)
    cloner = RepoCloner.new(repository)
    cloner.clone

    language = repository.language

    linter = LinterRouter.call(language)

    runner = Linters::BaseRunner.new(cloner.target_dir)
    runner.run(linter[:cmd])

    linter_json = runner.result

    parser = linter[:parser].new(linter_json, repository, check)
    parser.run
  end
end
