# frozen_string_literal: true

module RepoChecker
  class RubocopResult
    attr_reader :result

    def initialize(rubocop_json, repository, check)
      @result = { files: [] }

      return if rubocop_json.empty?

      rubocop_json['files'].each do |file|
        next if file['offenses'].empty?

        filepath = file['path'].split("#{repository.full_name}/").last
        github_file = "https://github.com/#{repository.full_name}/tree/#{check.commit_id}/#{filepath}"

        offenses = file['offenses'].map do |offense|
          {
            message: offense['message'],
            cop: offense['cop_name'],
            location: {
              line: offense['location']['line'],
              column: offense['location']['column']
            }
          }
        end

        @result[:files] << {
          path: github_file,
          offenses: offenses
        }
      end

      @result[:offense_count] = rubocop_json['summary']['offense_count']
    end
  end
end
