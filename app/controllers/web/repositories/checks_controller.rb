# frozen_string_literal: true

class Web::Repositories::ChecksController < Web::Repositories::ApplicationController
  def show
    @repository = current_user.repositories.find(params[:repository_id])
    @check = Repository::Check.find(params[:id])
  end

  def create
    @repository = current_user.repositories.find(params[:repository_id])
    @check = @repository.checks.build

    if @check.save
      RepoCheckerJob.perform_later(@repository, @check)
      @check.run!
      redirect_to @repository, notice: t('.success')
    else
      redirect_to @repository, notice: t('fail')
    end
  end

  # def permitted_params
  #   params.require(:check).permit(:repository_id)
  # end
end
