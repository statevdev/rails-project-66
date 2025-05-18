# frozen_string_literal: true

class RepoChecker::Linters::Rubocop::RubocopRunner < RepoChecker::Linters::BaseRunner
  CMD = 'bundle exec rubocop --format json --config .rubocop.yml'
end
