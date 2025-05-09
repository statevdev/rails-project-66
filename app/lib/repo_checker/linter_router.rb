# frozen_string_literal: true

require 'active_support/all'

module RepoChecker
  class LinterRouter
    LINTER_MAP = {
      'ruby' => 'rubocop',
      'javascript' => 'eslint'
    }.freeze

    def self.call(language)
      linter = LINTER_MAP[language.downcase].capitalize

      runner_class = "RepoChecker::Linters::#{linter}::#{linter}Runner"
      parser_class = "RepoChecker::Linters::#{linter}::#{linter}Parser"

      {
        cmd: runner_class.constantize::CMD,
        parser: parser_class.constantize
      }
    end
  end
end
