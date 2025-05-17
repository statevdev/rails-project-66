# frozen_string_literal: true

class Web::Repositories::RepositoriesController < Web::Repositories::ApplicationController
  before_action :authenticate_user!, only: :create

  def index
    @repositories = Repository.includes(:checks, :user)
                              .order(created_at: :desc)
                              .page(params[:page])
    authorize Repository
  end

  def show
    @repository = Repository.find(params[:id])
    @checks = @repository.checks.order(created_at: :desc).page(params[:page])
    authorize @repository
  end

  def new
    @repository = Repository.new
    authorize @repository

    @allowed_repos = ApplicationContainer[:octokit_client].allowed_repos(current_user)
  end

  def create
    @repository = current_user.repositories.build(permitted_params)

    @repository.save!
    RepositoryLoaderJob.perform_later(permitted_params[:github_id], current_user)
    redirect_to repositories_path, notice: t('success')
  end

  def permitted_params
    params.require(:repository).permit(:github_id)
  end
end
