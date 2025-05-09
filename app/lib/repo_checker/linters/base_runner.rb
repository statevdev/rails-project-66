# frozen_string_literal: true

require 'open3'
require 'json'

class RepoChecker::Linters::BaseRunner
  attr_reader :result

  def initialize(target_dir)
    @target_dir = target_dir
    @result = {}
  end

  def run(command)
    cmd = "#{command} #{@target_dir}"
    stdout, status = Open3.popen3(cmd) { |_stdin, stdout, _stderr, wait_thr| [stdout.read, wait_thr.value] }

    return {} if status.success?

    @result = JSON.parse(stdout)
  ensure
    FileUtils.rm_rf(@target_dir)
  end
end
