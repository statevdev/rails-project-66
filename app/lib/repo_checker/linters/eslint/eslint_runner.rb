# frozen_string_literal: true

class RepoChecker::Linters::Eslint::EslintRunner < RepoChecker::Linters::BaseRunner
  CMD = 'npx eslint --format json --config eslint.config.mjs '
end
