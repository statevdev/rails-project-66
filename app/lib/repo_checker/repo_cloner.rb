# frozen_string_literal: true

require 'fileutils'

module RepoChecker
  class RepoCloner
    attr_reader :target_dir

    TMP_DIR = File.expand_path('../../../tmp/repos', __dir__)

    def initialize(repository)
      @repo_name = repository.full_name
      @clone_url = repository.clone_url
      @target_dir = File.join(TMP_DIR, @repo_name)
    end

    def clone
      return if Dir.exist?(@target_dir)

      FileUtils.mkdir_p(File.dirname(@target_dir))
      system("git clone #{@clone_url} #{@target_dir}")
    end
  end
end
