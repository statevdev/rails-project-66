# frozen_string_literal: true

class User < ApplicationRecord
  has_many :repositories

  validates :email, :nickname, :token, presence: true, uniqueness: true
end
