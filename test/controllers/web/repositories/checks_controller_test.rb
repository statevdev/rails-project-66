# frozen_string_literal: true

require 'test_helper'

class Web::Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user)
  end

  test 'should create check' do
    sign_in @user

    repository = repositories(:one)

    post repository_checks_path(repository)

    check = Repository::Check.find_by(repository_id: repository.id)

    assert { check.finished? }
    assert_redirected_to repository
    assert { flash[:notice] == 'Check has start' }
    assert { check }
  end

  test 'should get show' do
    sign_in @user

    repository = repositories(:two)

    get repository_check_path(repository, repository_checks(:test))
    assert_response :success
  end

  test 'not authorize action' do
    get repositories_path

    assert_redirected_to root_path
    assert { flash[:alert] == 'Please, sign in.' }
  end
end
