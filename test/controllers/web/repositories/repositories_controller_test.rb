# frozen_string_literal: true

require 'test_helper'

class Web::Repositories::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user)
    @repository_attrs = { full_name: 'test/test' }
  end

  test 'should get index' do
    sign_in @user

    get repositories_path
    assert_response :success
  end

  test 'should get new' do
    sign_in @user

    get new_repository_path
    assert_response :success
  end

  test 'should get create' do
    sign_in @user

    post repositories_path, params: { repository: @repository_attrs }

    repository = Repository.find_by(@repository_attrs)

    assert_redirected_to repositories_path
    assert_equal 'Success!', flash[:notice]
    assert repository
  end

  test 'should get show' do
    sign_in @user

    get repository_path(repositories(:one))
    assert_response :success
  end

  test 'not authorize action' do
    get repositories_path

    assert_redirected_to root_path
    assert_equal 'Please, sign in.', flash[:alert]
  end
end
