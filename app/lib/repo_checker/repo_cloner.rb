# frozen_string_literal: true

module RepoChecker
  class RepoCloner
    attr_reader :target_dir

    TMP_DIR = Rails.root.join('tmp/repos')

    def initialize(repository)
      @repo_name = repository.full_name
      @clone_url = repository.clone_url
      @target_dir = TMP_DIR.join(@repo_name)
    end

    def clone
      return if @target_dir.exist?

      @target_dir.dirname.mkpath

      system("git clone #{@clone_url} #{@target_dir}")
    end
  end
end
