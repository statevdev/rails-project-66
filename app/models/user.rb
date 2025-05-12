# frozen_string_literal: true

class User < ApplicationRecord
  has_many :repositories

  validates :email, :token, presence: true, uniqueness: true
end
