# frozen_string_literal: true

module RepoChecker
  def self.run(full_name:, clone_url:, language:, commit_id:)
    cloner = RepoCloner.new(full_name, clone_url)
    cloner.clone

    linter = LinterRouter.call(language)

    runner = Linters::BaseRunner.new(cloner.target_dir)
    runner.run(linter[:cmd])

    linter_json = runner.result

    parser = linter[:parser].new(linter_json, full_name, commit_id)
    parser.run
  end
end
