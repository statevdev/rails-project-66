# frozen_string_literal: true

module RepoChecker
  def self.run(repository, check)
    Rails.logger.info('DEBUG -- Start cloning')
    cloner = RepoCloner.new(repository)
    cloner.clone

    language = repository.language

    Rails.logger.info('DEBUG -- Linter routing')
    linter = LinterRouter.call(language)

    Rails.logger.info('DEBUG -- Running linter')
    runner = Linters::BaseRunner.new(cloner.target_dir)
    runner.run(linter[:cmd])

    linter_json = runner.result

    parser = linter[:parser].new(linter_json, repository, check)
    parser.run
  end
end
