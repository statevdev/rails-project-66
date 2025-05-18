# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::Repositories::ApplicationController
  before_action :authenticate_user!

  def show
    @repository = current_user.repositories.find(params[:repository_id])
    @check = Repository::Check.find(params[:id])
  end

  def create
    @repository = current_user.repositories.find(params[:repository_id])
    @check = @repository.checks.build

    if @check.save
      @check.run!
      RepoCheckerJob.perform_now(@repository, @check)
      redirect_to @repository, notice: t('.success')
    else
      redirect_to @repository, notice: t('fail')
    end
  end
end
