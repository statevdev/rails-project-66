# frozen_string_literal: true

require 'test_helper'

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  test 'should create check' do
    repository = repositories(:one)

    json = { repository: { full_name: repository.full_name } }.to_json

    post api_checks_path, params: json, headers: { 'CONTENT_TYPE' => 'application/json' }

    check = Repository::Check.find_by(repository_id: repository.id)

    check.finished?

    assert { check }
  end
end
