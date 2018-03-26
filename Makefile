.PHONY: bundle test

bundle:
	@bundle install

test:
	@bundle exec rake
