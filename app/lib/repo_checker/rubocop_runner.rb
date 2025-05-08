# frozen_string_literal: true

require 'open3'
require 'json'

module RepoChecker
  class RubocopRunner
    def initialize(target_dir, config_path = default_config)
      @target_dir = target_dir
      @config_path = config_path
    end

    def run
      cmd = "rubocop --format json --config #{@config_path} #{@target_dir}"
      stdout, status = Open3.popen3(cmd) { |_stdin, stdout, _stderr, wait_thr| [stdout.read, wait_thr.value] }

      return {} if status.success?

      JSON.parse(stdout)
    end

    private

    def default_config
      File.expand_path('../../../.rubocop.yml', __dir__)
    end
  end
end
