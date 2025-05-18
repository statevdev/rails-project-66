# frozen_string_literal: true

module RepoChecker
  def self.run(full_name:, clone_url:, language:, commit_id:)
    Rails.logger.info('DEBUG -- Start cloning')
    cloner = RepoCloner.new(full_name, clone_url)
    cloner.clone

    Rails.logger.info('DEBUG -- Linter routing')
    linter = LinterRouter.call(language)

    Rails.logger.info('DEBUG -- Running linter')
    runner = Linters::BaseRunner.new(cloner.target_dir)
    runner.run(linter[:cmd])

    linter_json = runner.result
    Rails.logger.info("DEBUG -- Getting result: #{linter_json}")

    Rails.logger.info('DEBUG -- Running parser')
    parser = linter[:parser].new(linter_json, full_name, commit_id)
    parser.run
  end
end
