class Repository::Check < ApplicationRecord
  belongs_to :repository

  include AASM

  aasm do
    state :created, initial: true
    state :processing, :finished, :failed

    event :run do
      transitions from: %i[created finished failed], to: :processing
    end

    event :finish do
      transitions from: :processing, to: :finished
    end

    event :fail do
      transitions to: :failed
    end
  end

  # def result!
  #   Rails.cache.fetch("#{cache_key_with_version}/result/#{commit_id}", expires_in: 1.hours) do
  #     RepoCheckerJob.perform_later(repository_id)
  #   end
  # end
end
