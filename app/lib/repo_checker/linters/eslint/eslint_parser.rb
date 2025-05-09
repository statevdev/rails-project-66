# frozen_string_literal: true

class RepoChecker::Linters::Eslint::EslintParser < RepoChecker::Linters::BaseParser
  def parse_json
    offense_count = 0

    @json.each do |file|
      next if file['messages'].empty?

      github_file_path = get_github_file_path(file['filePath'])

      offenses = file['messages'].map do |message|
        offense_count += 1

        {
          message: message['message'],
          cop: message['ruleId'],
          location: {
            line: message['line'],
            column: message['column']
          }
        }
      end

      @result[:files] << {
        path: github_file_path,
        offenses: offenses
      }
    end

    @result[:offense_count] = offense_count
  end
end
