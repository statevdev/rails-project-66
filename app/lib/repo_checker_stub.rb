# frozen_string_literal: true

module RepoCheckerStub
  def self.run(_repository, _check)
    {
      files: [
        {
          path: 'test',
          offenses: [
            {
              message: 'Test',
              cop: 'Test/Test',
              location: {
                line: 1,
                column: 1
              }
            }
          ]
        }
      ]
    }
  end
end
