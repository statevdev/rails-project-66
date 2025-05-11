# frozen_string_literal: true

module RepoCheckerStub
  def self.run(_repository, _check)
    # {
    { files: [] }
    #     {
    #       path: 'test',
    #       offenses: []
    #     }
    #   ]
    # }
  end
end
