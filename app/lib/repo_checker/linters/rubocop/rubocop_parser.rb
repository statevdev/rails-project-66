# frozen_string_literal: true

class RepoChecker::Linters::Rubocop::RubocopParser < RepoChecker::Linters::BaseParser
  def parse_json
    @json['files'].each do |file|
      next if file['offenses'].empty?

      github_file_path = get_github_file_path(file['path'])

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
        path: github_file_path,
        offenses: offenses
      }
    end

    @result[:offense_count] = @json['summary']['offense_count']
  end
end
