# frozen_string_literal: true

require 'dry-container'

User = Struct.new(:name, :email)

data_store = Concurrent::Map.new.tap do |ds|
  ds[:users] = Concurrent::Array.new
end

# Initialize container
container = Dry::Container.new

# Register an item with the container to be resolved later
container.register(:data_store, data_store)
container.register(:user_repository, -> { container.resolve(:data_store)[:users] })

# Resolve an item from the container
container.resolve(:user_repository) << User.new('Jack', 'jack@dry-container.com')
# You can also resolve with []
container[:user_repository] << User.new('Jill', 'jill@dry-container.com')
# => [
#      #<struct User name="Jack", email="jack@dry-container.com">,
#      #<struct User name="Jill", email="jill@dry-container.com">
#    ]

# If you wish to register an item that responds to call but don't want it to be
# called when resolved, you can use the options hash
container.register(:proc, -> { :result }, call: false)
container.resolve(:proc)
# => #<Proc:0x007fa75e652c98@(irb):25 (lambda)>

# You can also register using a block
container.register(:item) do
  :result
end
container.resolve(:item)
# => :result

container.register(:block, call: false) do
  :result
end
container.resolve(:block)
# => #<Proc:0x007fa75e6830f0@(irb):36>

# You can also register items under namespaces using the #namespace method
container.namespace('repositories') do
  namespace('checkout') do
    register('orders') { Concurrent::Array.new }
  end
end
container.resolve('repositories.checkout.orders')
# => []

# Or import a namespace
ns = Dry::Container::Namespace.new('repositories') do
  namespace('authentication') do
    register('users') { Concurrent::Array.new }
  end
end
container.import(ns)
container.resolve('repositories.authentication.users')
# => []

# Also, you can import namespaces in container class
Repositories = Dry::Container::Namespace.new('repositories') do
  namespace('authentication') do
    register('users') { Concurrent::Array.new }
  end
end

class Container
  extend Dry::Container::Mixin
  import Repositories
end

Container.resolve('repositories.authentication.users')
# => []
