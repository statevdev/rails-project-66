setup:
	bundle
	bin/rails assets:precompile
	bin/rails db:migrate
start:
	bin/rails s
lint:
	bundle exec rubocop
	bundle exec slim-lint app/views/
autolint:
	bundle exec rubocop -A
tests:
	bin/rails test
github_env:
	cp -n .env.example .env || exit 0