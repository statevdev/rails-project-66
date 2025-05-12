# frozen_string_literal: true

module RepoCheckerStub
  def self.run(_repository, _check)
    { files: [] }
  end
end
