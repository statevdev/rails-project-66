class User < ApplicationRecord
  validates :email, :nickname, :token, presence: true, uniqueness: true
end
