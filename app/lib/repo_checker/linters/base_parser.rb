# frozen_string_literal: true

class RepoChecker::Linters::BaseParser
  attr_reader :result

  def initialize(json, repository, check)
    @json = json
    @repository = repository
    @check = check
    @result = { files: [] }
  end

  def run
    return @json if @json.empty?

    parse_json
    result
  end

  def parse_json; end

  def get_github_file_path(filepath)
    relative_path = filepath.split("#{@repository.full_name}/").last
    "https://github.com/#{@repository.full_name}/tree/#{@check.commit_id}/#{relative_path}"
  end
end
