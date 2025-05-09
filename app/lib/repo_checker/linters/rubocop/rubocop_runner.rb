# frozen_string_literal: true

class RepoChecker::Linters::Rubocop::RubocopRunner < RepoChecker::Linters::BaseRunner
  CMD = 'rubocop --format json '
end
