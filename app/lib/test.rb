# frozen_string_literal: true

require_relative '../../config/environment'
class Test
  def self.test
    return unless __FILE__ == $PROGRAM_NAME

    RepoChecker.run(Repository.first, Repository.first.checks.last)
    # Rails.logger.debug repo
  end
end

# puts Test.test
