# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require_relative '../app'

require 'pry'
require 'rack/test'
require 'rspec'
require 'webmock/rspec'
require 'faker'

WebMock.disable_net_connect!
OmniAuth.config.test_mode = true

Dir[File.expand_path('spec/support/**/*.rb')].each do |file|
  # Skip migrations as they're loaded when needed.
  next if file.include?('/migrations/')

  require file
end

RSpec.configure do |config|
  include Rack::Test::Methods
  include Spec::Support::Helpers
  include Spec::Support::GraphqlHelpers

  config.backtrace_exclusion_patterns << %r{spec/spec_helper.rb}
  config.backtrace_exclusion_patterns << %r{/gems/}
  config.order = 'random'

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    # NOTE (ayrton): We should always default to the transaction strategy.
    # The truncation strategy is only required when after_commit hooks are needed or when code is multithreaded.
    if cleanup_strategy = example.metadata[:clean_database_with]
      example.run
      DatabaseCleaner[:sequel, connection: Yorca.database].clean_with(cleanup_strategy)
    else
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner[:sequel, connection: Yorca.database].cleaning do
        example.run
      end
    end
  end
end
