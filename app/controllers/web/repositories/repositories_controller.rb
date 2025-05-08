# frozen_string_literal: true

class Web::Repositories::RepositoriesController < Web::Repositories::ApplicationController
  def index
    @repositories = Repository.all
    authorize Repository
  end

  def show
    @repository = Repository.find(params[:id])
    @checks = @repository.checks
    authorize @repository
  end

  def new
    @repository = Repository.new
    authorize @repository

    @full_names = ApplicationContainer[:octokit_client].allowed_repos(current_user)
  end

  def create
    @repository = current_user.repositories.build(permitted_params) if signed_in?
    authorize Repository

    if @repository.save
      RepositoryLoaderJob.perform_later(permitted_params[:full_name], current_user)
      redirect_to repositories_path, notice: t('success')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def permitted_params
    params.require(:repository).permit(:full_name)
  end
end
