# frozen_string_literal: true

class Web::RepositoriesController < Web::ApplicationController
  def index
    @repositories = Repository.all
    authorize Repository
  end

  def show
    @repository = Repository.find(params[:id])
    authorize @repository
  end

  def new
    @repository = Repository.new
    authorize @repository

    client = Octokit::Client.new access_token: current_user.token, auto_paginate: true

    @full_names = client.repos.filter_map do |repo|
      if Repository.language.values.include?(repo[:language])
        repo[:full_name]
      end
    end
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
