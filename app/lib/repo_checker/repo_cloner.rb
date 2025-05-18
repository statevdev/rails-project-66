# frozen_string_literal: true

module RepoChecker
  class RepoCloner
    attr_reader :target_dir

    TMP_DIR = Rails.root.join('tmp/repos')

    def initialize(full_name, clone_url)
      @full_name = full_name
      @clone_url = clone_url
      @target_dir = TMP_DIR.join(@full_name)
    end

    def clone
      return if @target_dir.exist?

      @target_dir.dirname.mkpath

      system("git clone #{@clone_url} #{@target_dir}")
    end
  end
end
