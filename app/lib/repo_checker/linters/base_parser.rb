# frozen_string_literal: true

class RepoChecker::Linters::BaseParser
  attr_reader :result

  def initialize(json, full_name, commit_id)
    @json = json
    @full_name = full_name
    @commit_id = commit_id
    @result = { files: [] }
  end

  def run
    return @json if @json.empty?

    parse_json
    result
  end

  def parse_json; end

  def get_github_file_path(filepath)
    relative_path = filepath.split("#{@full_name}/").last
    "https://github.com/#{@full_name}/tree/#{@commit_id}/#{relative_path}"
  end
end
